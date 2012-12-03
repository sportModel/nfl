#include <math.h>
#include <string.h>
#include "Rinternals.h"
#include "R_ext/Rdynload.h"
#include <R.h>
#include <R_ext/Applic.h>

static double *vector(int n);
static void free_vector(double *v);
static double **matrix(int nr, int nc);
static void free_matrix(double **M, int nr);
static double **as_matrix(double *v, int nr, int nc);
static void *as_vector(double *v, double **M, int nr, int nc);

static double *vector(int n)
{
  double *v;
  v = Calloc(n, double);
  return v;
}

static void free_vector(double *v)
{
  Free(v);
}

static double **matrix(int nr, int nc)
{
  int   i;
  double **M;
  M = Calloc(nr, double *);
  for (i = 0; i < nr; i++) M[i] = Calloc(nc, double);
  return M;
}

static void free_matrix(double **M, int nr)
{
  int   i;
  for (i = 0; i < nr; i++) Free(M[i]);
  Free(M);
}

static double **as_matrix(double *v, int nr, int nc)
{
  int i,j;
  double **M;

  M = Calloc(nr, double *);

  for (i = 0; i < nr; i++) M[i] = Calloc(nc, double);
  for (j = 0; j < nc; j++)
    {
      for (i = 0; i < nr; i++) M[i][j] = v[j*nr+i];
    }
  return M;
}

static void *as_vector(double *v,double **M, int nr, int nc)
{
  int i,j;

  for (j = 0; j < nc; j++)
    {
      for (i = 0; i < nr; i++) v[j*nr+i] = M[i][j];
    }
}

static int checkConvergence(double *beta_new, double *beta_old, double eps, int p)
{
  int j;
  int converged = 1;
  for (j=0; j < p; j++)
    {
      if (fabs(beta_new[j]-beta_old[j]) > eps)
	{
	  converged = 0;
	  break;
	}
    }
  /*Rprintf("Checking convergence:\n");
  Rprintf("%f %f %f\n",beta_new[0],beta_new[1],beta_new[2]);
  Rprintf("%f %f %f\n",beta_old[0],beta_old[1],beta_old[2]);
  Rprintf("Converged: %d\n",converged);*/
  return(converged);
}

static double S(double x,double y)
{
  if (fabs(x) <= y) return(0);
  else
    {
      if (x > 0) return(x-y);
      else return(x+y);
    }
}

static double SCAD(double theta, double l, double a)
{
  theta = fabs(theta);
  if (theta <= l) return(theta*l);
  else if (theta < l*a) return((a*l*theta - (pow(theta,2)+pow(l,2))/2)/(a-1));
  else return((pow(l,2)*(pow(a,2)-1))/(2*(a-1)));
}

static void gLasso(double *beta, double **X, double *r, int K0, int Kj, int n, double lambda, double alpha, int normalized, double *penpars)
{
  int i, j, k, j1, j2, k1, k2, K;
  K = Kj - K0;
  double sxr, sxx, oldbeta, gradient_norm, gradient_k, sbb;

  /* Calculate gradient_norm */
  gradient_norm = 0;
  for (j1=K0; j1<Kj; j1++)
    {
      gradient_k = 0;
      k1 = j1 - K0;
      for (i=0; i<n; i++)
	{
	  gradient_k = gradient_k + X[i][j1]*r[i];
	  for (j2=K0; j2<Kj; j2++)
	    {
	      k2 = j2 - K0;
	      gradient_k = gradient_k + X[i][j1]*X[i][j2]*beta[j2];
	    }
	}
      gradient_norm = gradient_norm + pow(gradient_k,2);
    }
  gradient_norm = sqrt(gradient_norm);
  /*Rprintf("%f\n",gradient_norm);*/
  /*printf("%f\n",lambda);*/
  if (gradient_norm/n > alpha * lambda)
    {
      if (beta[K0]==0) sbb=.00000001;
      else
	{
	  sbb = 0;
	  for (j=K0; j<Kj; j++) sbb = sbb + pow(beta[j],2);
	}
      for (j=K0; j<Kj; j++)
	{
	  oldbeta = beta[j];
	  sxr=0;
	  for (i=0; i<n; i++) sxr = sxr + X[i][j]*r[i];
	  if (normalized) sxx = n;
	  else
	    {
	      sxx = 0;
	      for (i=0; i<n; i++) sxx = sxx + pow(X[i][j],2);
	    }
	  beta[j] = (sxr+sxx*oldbeta)/(sxx+n*alpha*lambda/sqrt(sbb));
	  /*Rprintf("%d %f %f\n",j,oldbeta,beta[j]);*/
	  for (i=0; i<n; i++) r[i] = r[i] - (beta[j]-oldbeta)*X[i][j];
	  sbb = sbb + pow(beta[j],2) - pow(oldbeta,2);
	}
    }
  else
    {
      for (j=K0; j<Kj; j++)
	{
	  if (beta[j]==0) continue;
	  else
	    {
	      oldbeta = beta[j];
	      beta[j] = 0;
	      for (i=0; i<n; i++) r[i] = r[i] + oldbeta*X[i][j];
	    }
	}
    }
}

static void gBridge(double *beta, double **X, double *r, int K0, int Kj, int n, double lambda, double alpha, int normalized, double *penpars)
{
  int i, j, K;
  K = Kj - K0;
  double sxr, sxx, oldbeta, sab, gamma;
  gamma = penpars[0];
  /*Rprintf("%f %f %f %f %f\n",beta[0],beta[1],beta[2],beta[3],beta[4]);*/

  sab = 0;
  for (j=K0; j<Kj; j++) sab = sab + fabs(beta[j]);
  if (sab==0) return;

  for (j=K0; j<Kj; j++)
    {
      if (sab < .0001)
	{
	  beta[j] = 0;
	  continue;
	}
      oldbeta = beta[j];
      sxr=0;
      for (i=0; i<n; i++) sxr = sxr + X[i][j]*r[i];
      if (normalized) sxx = n;
	  else
	    {
	      sxx = 0;
	      for (i=0; i<n; i++) sxx = sxx + pow(X[i][j],2);
	    }
      beta[j] = S(sxr+sxx*oldbeta,n*alpha*lambda*gamma*pow(sab,gamma-1))/sxx;
      /*Rprintf("%f %f\n",sab,beta[j]);*/
      for (i=0; i<n; i++) r[i] = r[i] - (beta[j]-oldbeta)*X[i][j];
      sab = sab + fabs(beta[j]) - fabs(oldbeta);
    }
}

static double dSCAD(double theta, double l, double a)
{
  theta = fabs(theta);
  if (theta < l) return(l);
  else if (theta < a*l) return((a*l-theta)/(a-1));
  else return(0);
}

static void gSCAD1(double *beta, double **X, double *r, int K0, int Kj, int n, double lambda, double alpha, int normalized, double *penpars)
{
  int i, j, K;
  K = Kj - K0;
  double sxr, sxx, oldbeta, sab, a, dp, theta;
  a = penpars[0];
  /*Rprintf("%f %f %f %f %f\n",beta[0],beta[1],beta[2],beta[3],beta[4]);*/

  sab = 0;
  for (j=K0; j<Kj; j++) sab = sab + fabs(beta[j]);

  for (j=K0; j<Kj; j++)
    {
      oldbeta = beta[j];
      sxr=0;
      for (i=0; i<n; i++) sxr = sxr + X[i][j]*r[i];
      if (normalized) sxx = n;
	  else
	    {
	      sxx = 0;
	      for (i=0; i<n; i++) sxx = sxx + pow(X[i][j],2);
	    }
      beta[j] = S(sxr+sxx*oldbeta,n*alpha*dSCAD(sab,lambda,a)/K)/sxx;
      /*Rprintf("%f %f\n",sab,beta[j]);*/
      for (i=0; i<n; i++) r[i] = r[i] - (beta[j]-oldbeta)*X[i][j];
      sab = sab + fabs(beta[j]) - fabs(oldbeta);
    }
}

static void gSCAD2(double *beta, double **X, double *r, int K0, int Kj, int n, double lambda, double alpha, int normalized, double *penpars)
{
  int i, j, K;
  K = Kj - K0;
  double sxr, sxx, oldbeta, sscad, a, theta, phi, dp;
  a = penpars[0];
  phi = (2*a*(a-1))/(K*lambda*(pow(a,2)-1));
  /*Rprintf("%f %f %f %f %f\n",beta[0],beta[1],beta[2],beta[3],beta[4]);*/

  sscad = 0;
  for (j=K0; j<Kj; j++) sscad = sscad + SCAD(beta[j],lambda,a);

  for (j=K0; j<Kj; j++)
    {
      oldbeta = beta[j];
      sxr=0;
      for (i=0; i<n; i++) sxr = sxr + X[i][j]*r[i];
      if (normalized) sxx = n;
	  else
	    {
	      sxx = 0;
	      for (i=0; i<n; i++) sxx = sxx + pow(X[i][j],2);
	    }
      if (lambda==0) dp = 0;
      else dp = phi*dSCAD(phi*sscad,lambda,a)*dSCAD(oldbeta,lambda,a);
      /*Rprintf("%f %f %f\n",phi,dSCAD(phi*sscad,lambda,a),dSCAD(oldbeta,lambda,a));*/
      beta[j] = S(sxr+sxx*oldbeta,n*alpha*dp)/sxx;
      /*Rprintf("%f %f\n",sab,beta[j]);*/
      for (i=0; i<n; i++) r[i] = r[i] - (beta[j]-oldbeta)*X[i][j];
      sscad = sscad + SCAD(beta[j],lambda,a) - SCAD(oldbeta,lambda,a);
    }
}

static void gSCAD_defunct(double *beta, double **X, double *r, int K0, int Kj, int n, double lambda, double alpha, int normalized, double *penpars)
{
  int i, j, K;
  K = Kj - K0;
  double sxr, sxx, oldbeta, sscad, a, theta, dp;
  a = penpars[0];
  /*Rprintf("%f %f %f %f %f\n",beta[0],beta[1],beta[2],beta[3],beta[4]);*/

  sscad = 0;
  for (j=K0; j<Kj; j++) sscad = sscad + SCAD(beta[j],sqrt(lambda/K),a);

  for (j=K0; j<Kj; j++)
    {
      oldbeta = beta[j];
      sxr=0;
      for (i=0; i<n; i++) sxr = sxr + X[i][j]*r[i];
      if (normalized) sxx = n;
	  else
	    {
	      sxx = 0;
	      for (i=0; i<n; i++) sxx = sxx + pow(X[i][j],2);
	    }
      if (lambda==0) dp = 0;
      else dp = dSCAD(sscad,sqrt(lambda*K),a)*dSCAD(oldbeta,sqrt(lambda/K),a);
      /*Rprintf("%f %f %f\n",phi,dSCAD(phi*sscad,lambda,a),dSCAD(oldbeta,lambda,a));*/
      beta[j] = S(sxr+sxx*oldbeta,n*alpha*dp)/sxx;
      /*Rprintf("%f %f\n",sab,beta[j]);*/
      for (i=0; i<n; i++) r[i] = r[i] - (beta[j]-oldbeta)*X[i][j];
      sscad = sscad + SCAD(beta[j],sqrt(lambda/K),a) - SCAD(oldbeta,sqrt(lambda/K),a);
    }
}

static void gcdStep(double *beta, double **X, double *r, int *group, char *family, int n, int p, int J, int *K, char *penalty, double lambda, double *penpars, double *alpha, int normalized)
{
  int g,i,j;
  int K0,Kj;
  double sxr, sxx, oldbeta;

  /* Approximate L                 */
  /* Update unpenalized covariates */

  for (j=0;; j++)
    {
      if (group[j]!=0) break;
      if (normalized) sxx = n;
      else
	{
	  sxx = 0;
	  for (i=0; i<n; i++) sxx = sxx + pow(X[i][j],2);
	}
      sxr=0;
      for (i=0; i<n; i++) sxr = sxr + X[i][j]*r[i];
      oldbeta = beta[j];
      beta[j] = sxr/sxx + beta[j];
      for (i=0; i<n; i++) r[i] = r[i] - (beta[j]-oldbeta)*X[i][j];
    }
  for (g=0; g<J; g++)
    {
      K0 = j;
      Kj = j + K[g];
      /*Rprintf("%d %d\n",K0,Kj);*/
      /*Rprintf("%f %f %f %f %f\n",beta[0],beta[1],beta[2],beta[3],beta[4]);*/
      if (strcmp(penalty,"gLasso")==0) gLasso(beta,X,r,K0,Kj,n,lambda,alpha[g],normalized,penpars);
      if (strcmp(penalty,"gBridge")==0) gBridge(beta,X,r,K0,Kj,n,lambda,alpha[g],normalized,penpars);
      if (strcmp(penalty,"gSCAD1")==0) gSCAD1(beta,X,r,K0,Kj,n,lambda,alpha[g],normalized,penpars);
      if (strcmp(penalty,"gSCAD2")==0) gSCAD2(beta,X,r,K0,Kj,n,lambda,alpha[g],normalized,penpars);
      if (strcmp(penalty,"gSCAD.defunct")==0) gSCAD_defunct(beta,X,r,K0,Kj,n,lambda,alpha[g],normalized,penpars);
      j = Kj;
    }
}

static void gpFit(double *beta, int *counter, double *x, double *y, int *group, char **family, int *n, int *p, int *J, int *K, char **penalty, double *lambda, double *eps, int *max_iter, int *verbose, int *monitor, int *n_monitor, double *alpha, int *normalized, double *beta_old, double *penpars)
{
  /*Rprintf("beta[1]: %f\n",beta[0]);
  Rprintf("counter: %d\n",counter[0]);
  Rprintf("x[1]: %f\n",x[0]);
  Rprintf("y[1]: %f\n",y[0]);
  Rprintf("max_iter[1]: %d\n",max_iter[0]);*/

  int i,j;
  int converged=0;
  double **X;
  X = as_matrix(x,*n,*p);
  double *r;
  r = vector(*n);
  for (i=0;i<*n;i++)
    {
      r[i] = y[i];
      for (j=0;j<*p;j++)
	{
	  r[i] = r[i] - X[i][j]*beta_old[j];
	}
    }
  while (counter[0] < max_iter[0])
    {
      counter[0] = counter[0] + 1;
      if (*verbose) Rprintf("Iteration: %d\n",counter[0]);
      gcdStep(beta,X,r,group,family[0],*n,*p,*J,K,penalty[0],*lambda,penpars,alpha,*normalized);
      /*Rprintf("%d %d\n",counter[0],max_iter[0]);
      Rprintf("%f %f %f\n",beta_new[0],beta_new[1],beta_new[2]);
      Rprintf("%f %f %f\n",beta_old[0],beta_old[1],beta_old[2]);*/
      if (*n_monitor != 0)
	{
	  for (i=0; i<*n_monitor;i++) Rprintf("%.2f ",beta[monitor[i]]);
	  Rprintf("\n");
	}
      if (checkConvergence(beta,beta_old,*eps,*p))
	{
	  converged  = 1;
	  break;
	}
      for (j=0;j<*p;j++) beta_old[j] = beta[j];
    }
  if (converged==0) warning("Failed to converge");
}

static void gibbs(double *beta, double *h, double *x, double *y, double *prior_beta, double *prior_h, double *prior_v, double *prior_s2, int *N, double *w1, double *w2, double *n, double *p, double *xtx, double *Xty)
{
  int i,j;
  double h;
  double **X;
  X = as_matrix(x,*n,*p);
  double **XtX;
  XtX = as_matrix(xtx,*p,*p);
  double **prior_H;
  prior_H = as_matrix(prior_h,*p,*p);
  double **Beta;
  Beta = matrix(*N,*p);

  for (i==0; i<*N; i++)
    {

    }
}

static const R_CMethodDef cMethods[] = {
  {"gibbs", (DL_FUNC) &gibbs, 21},
  NULL
};

void R_init_gibbs(DllInfo *info)
{
  R_registerRoutines(info,cMethods,NULL,NULL,NULL);
}
