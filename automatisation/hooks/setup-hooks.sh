#!/bin/bash

echo "Installation des hooks..."

cp automatisation/hooks/post-merge .git/hooks/post-merge
chmod +x .git/hooks/post-merge

echo "Hooks installés."