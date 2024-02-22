#!/bin/bash

# Yesterday's tasks are things that ended sometime after yesterday (00:00) or anything started before today (00:00)
yesterdays_tasks_json=$(t '(((end > yesterday and entry < today) or (start < today and status:pending)) and (status != deleted))' export)
# Today's tasks are anything that is started
todays_tasks_json=$(t '((start < now and status:pending) or (end > today and status != deleted))' export)

# Generate SCRUM status
echo "Scrum Update:"

# Process yesterday's tasks
echo "- Y:"
echo "$yesterdays_tasks_json" | jq -r '.[] | "    - \(.description)"'

# Process today's tasks
echo "- T:"
echo "$todays_tasks_json" | jq -r '.[] | "    - \(.description)"'
