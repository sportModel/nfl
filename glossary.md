---
layout: default
---

Predictions:

* **PrHome** Probability of the home team winning
* **E[Home]** Posterior mean of the score of the home team


<b>E[Home]</b> Posterior mean of the score of the away team.<br><br>
<b>Spread</b> Final betting line on the game, in terms of home team's score minus away team's score (as reported by Yahoo sports).<br><br>
<b>PrS-</b> Total posterior probability of all spreads below the one listed as <b>spread</b>.<br><br>
<b>PrS+</b> Total posterior probability of all spreads above the one listed in <b>spread</b>.<br><br>
<i>Example</i> <b>Spread</b> = 3 means that the home team is favored by three.  <b>PrS-</b> therefore includes the total posterior probability of all outcomes in which the home team loses or wins by less than three, while <b>PrS+</b> is the sum of the posterior probability of all outcomes in which the home team wins by more than three.  Because there is a substantial probability that the home team will win by exactly three points, these probabilities will not sum to 1 (although <b>PrS-</b> + <b>PrS+</b> will equal 1 if the spread is not an integer- say, 3.5).
<br>
<br>
<br>
Team Parameters:
<br>
<br>
<b>Offense</b> Number of points the team would be expected to score against a perfectly average opponent on a neutral field.  See methodology for a more mathematical definition.<br><br>
<b>Defense</b> Number of points the team would be expected to allow against a perfectly average opponent on a neutral field.  See methodology for a more mathematical definition.<br><br>
<b>Diff</b> Expected winning margin of the team against a perfectly average opponent on a neutral field.  This is just <b>Offense</b> minus <b>Defense</b>.  See methodology for a more mathematical definition.<br><br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

