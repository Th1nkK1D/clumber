#!/usr/bin/env bash
jq -r '
  def bar: if . == null then "░░░░░░░░░░" else
    ([., 0] | max | [., 100] | min) as $p | (($p / 10) | round) as $n
    | ("█" * $n) + ("░" * (10 - $n)) end;
  def seg($l): "\($l) \(.used_percentage | bar) \(.used_percentage | if . == null then "-" else "\(floor)%" end)";
  [ ((.model.display_name // "?") + (if .effort.level then " (\(.effort.level))" else "" end)),
    (.context_window | seg("ctx")),
    (.rate_limits.five_hour // empty | seg("5h")),
    (.rate_limits.seven_day // empty | seg("7d")),
    "$\((.cost.total_cost_usd // 0) * 100 | round / 100)"
  ] | join(" | ")
'
