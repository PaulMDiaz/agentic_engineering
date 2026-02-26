#!/bin/bash
# Add skills as commands so they work as /skill-name in Cursor

for skill in agent-review diff-summary git-recap init-second-brain load-second-brain update-second-brain; do
  ln -sf ~/Documents/development/agentic_engineering/skills/$skill.md ~/.cursor/commands/$skill.md
  echo "Linked $skill"
done

echo "Done. Restart Cursor and check /agent-review etc."
