echo "Disabling IPv6..."

cat <<'EOF' | sudo tee /etc/sysctl.d/disable-ipv6.conf >/dev/null
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
sudo sysctl --system >/dev/null

# tests
test $(sudo sysctl -n net.ipv6.conf.all.disable_ipv6) = 1
test $(sudo sysctl -n net.ipv6.conf.default.disable_ipv6) = 1
test $(sudo sysctl -n net.ipv6.conf.lo.disable_ipv6) = 1
