#!/usr/bin/env bash

nft -f - <<'EOF'
table inet filter {}
delete table inet filter
EOF
