#!/bin/bash

set -euo pipefail

if [[ ${DEBUG:-0} -eq 1 ]]; then
  set -x
fi

# Yesterday's tasks are things that ended sometime after yesterday (00:00) or anything started before today (00:00)
yesterdays_completed_tasks_json=$(t '((end > yesterday and entry < today) and (status = completed))' export)
yesterdays_tasks_json=$(t '(((end > yesterday and entry < today) or (start < today and status:pending)) and (status != deleted and status != completed))' export)
# Today's completed tasks
todays_completed_tasks_json=$(t '((start < now and status:pending) or (end > today and status = completed))' export)
# Today's tasks are anything that is started and is not completd
todays_tasks_json=$(t '((start < now and status:pending) or (end > today and status != deleted and status != completed))' export)

if [[ ${DEBUG:-0} -eq 1 ]]; then
  set +x
fi

# Generate SCRUM status
echo "Scrum Update:"

# Process yesterday's tasks
echo "- Y:"
echo "$yesterdays_completed_tasks_json" | jq -r '.[] | "    - \(.description) *(completed)*"' | sort -u
echo "$yesterdays_tasks_json" | jq -r '.[] | "    - \(.description)"' | sort -u

# Process today's tasks
echo "- T:"
echo "$todays_completed_tasks_json" | jq -r '.[] | "    - \(.description) *(completed)*"' | sort -u
echo "$todays_tasks_json" | jq -r '.[] | "    - \(.description)"' | sort -u
