#!/bin/bash

# Add this function to your ~/.bashrc or ~/.zshrc

# Tailscale setup function for manual installation
tailscale-setup() {
    # Set server name (uses hostname by default)
    export TAILSCALE_SERVER_NAME=$(hostname -s)
    
    # Set SOCKS5/HTTP proxy port (random if not already set)
    export TAILSCALE_SERVER_PORT=${TAILSCALE_SERVER_PORT:-$((10000 + RANDOM % 55536))}
    
    # Set socket file location
    export TAILSCALE_SOCKET="$HOME/.tailscaled-${USER}.${TAILSCALE_SERVER_NAME}.sock"
    
    echo "Tailscale environment configured:"
    echo "  SERVER_NAME: ${TAILSCALE_SERVER_NAME}"
    echo "  SERVER_PORT: ${TAILSCALE_SERVER_PORT}"
    echo "  SOCKET: ${TAILSCALE_SOCKET}"
}

# Start Tailscale daemon in background
tailscale-start() {
    # Ensure environment is configured
    tailscale-setup
    
    # Check if tailscaled is already running
    if pgrep -f "tailscaled.*${TAILSCALE_SOCKET}" > /dev/null; then
        echo "Tailscale daemon is already running"
        return 1
    fi
    
    # Start tailscaled with userspace networking (no root required)
    nohup tailscaled \
        -tun=userspace-networking \
        --socks5-server=localhost:${TAILSCALE_SERVER_PORT} \
        -outbound-http-proxy-listen=localhost:${TAILSCALE_SERVER_PORT} \
        -socket ${TAILSCALE_SOCKET} > /tmp/tailscaled.log 2>&1 &
    
    echo "Tailscale daemon started (PID: $!)"
    echo "Log file: /tmp/tailscaled.log"
    sleep 2
}

# Connect to Tailnet
tailscale-connect() {
    # Ensure environment is configured
    tailscale-setup
    
    # Connect to tailnet
    tailscale --socket=${TAILSCALE_SOCKET} up "$@"
}

# Stop Tailscale daemon
tailscale-stop() {
    tailscale-setup
    
    # Gracefully disconnect
    tailscale --socket=${TAILSCALE_SOCKET} down 2>/dev/null
    
    # Kill the daemon process
    pkill -f "tailscaled.*${TAILSCALE_SOCKET}"
    
    echo "Tailscale daemon stopped"
}

# Check Tailscale status
tailscale-status() {
    tailscale-setup
    tailscale --socket=${TAILSCALE_SOCKET} status
}

# Download and install Tailscale static binaries
tailscale-install() {
    local INSTALL_DIR="${1:-$HOME/.local/bin}"
    
    echo "Installing Tailscale to: ${INSTALL_DIR}"
    mkdir -p "${INSTALL_DIR}" || true
    
    # Download the latest static binaries
    export TS_VERSION=$(curl -L https://api.github.com/repos/tailscale/tailscale/releases/latest | jq -r '.tag_name[1:]')
    echo "Latest version: ${TS_VERSION}"
    
    wget https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-amd64 -O ${INSTALL_DIR}/jq && chmod +x ${INSTALL_DIR}/jq
    wget https://pkgs.tailscale.com/stable/tailscale_${TS_VERSION}_amd64.tgz -O /tmp/tailscale.tgz
    tar -xzf /tmp/tailscale.tgz -C /tmp
    
    # Copy binaries to install directory
    cp /tmp/tailscale_${TS_VERSION}_amd64/* "${INSTALL_DIR}/"
    chmod +x "${INSTALL_DIR}/tailscale" "${INSTALL_DIR}/tailscaled"
    
    # Cleanup
    rm -rf /tmp/tailscale.tgz /tmp/tailscale_${TS_VERSION}_amd64
    
    echo "Tailscale installed successfully!"
    echo "Make sure ${INSTALL_DIR} is in your PATH"
}

# Usage help
tailscale-help() {
    cat << 'EOF'
Tailscale Management Functions:

  tailscale-install [DIR]     - Download and install Tailscale binaries (default: ~/.local/bin)
  tailscale-setup              - Configure environment variables
  tailscale-start              - Start Tailscale daemon in background
  tailscale-connect [OPTIONS]  - Connect to your Tailnet
                                 Examples:
                                   tailscale-connect
                                   tailscale-connect --accept-routes --accept-dns
  tailscale-status             - Show Tailscale connection status
  tailscale-stop               - Stop Tailscale daemon
  tailscale-help               - Show this help message

Quick Start:
  1. tailscale-install         # Install binaries (if not already installed)
  2. tailscale-start           # Start the daemon
  3. tailscale-connect         # Connect to your Tailnet

EOF
}
