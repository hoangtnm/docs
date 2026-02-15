#!/usr/bin/env bash

set -euo pipefail

# Constants
readonly INSTALL_DIR="${HOME}/.local/bin"
readonly LIB_DIR="${HOME}/.local/lib"
readonly DOWNLOAD_FILE="ollama-linux-amd64.tar.zst"
readonly TEMP_DIR="$(mktemp -d)"

# Cleanup on exit
cleanup() {
    local exit_code=$?
    if [[ -d "${TEMP_DIR}" ]]; then
        rm -rf "${TEMP_DIR}"
    fi
    if [[ ${exit_code} -ne 0 ]]; then
        echo "Error: Installation failed" >&2
    fi
}
trap cleanup EXIT

# Check dependencies
check_dependencies() {
    local deps=(curl jq wget tar)
    local missing=()
    
    for cmd in "${deps[@]}"; do
        if ! command -v "${cmd}" &> /dev/null; then
            missing+=("${cmd}")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Error: Missing required dependencies: ${missing[*]}" >&2
        exit 1
    fi
}

# Main installation
main() {
    echo "Checking dependencies..."
    check_dependencies
    
    echo "Fetching latest Ollama version..."
    local ollama_version
    ollama_version=$(curl -fsSL https://api.github.com/repos/ollama/ollama/releases/latest | jq -r '.tag_name[1:]')
    
    if [[ -z "${ollama_version}" ]]; then
        echo "Error: Failed to fetch Ollama version" >&2
        exit 1
    fi
    
    echo "Latest version: ${ollama_version}"
    
    local ollama_url="https://github.com/ollama/ollama/releases/download/v${ollama_version}/${DOWNLOAD_FILE}"
    local download_path="${TEMP_DIR}/${DOWNLOAD_FILE}"
    
    echo "Downloading Ollama..."
    wget -q --show-progress "${ollama_url}" -O "${download_path}"
    
    echo "Extracting archive..."
    tar -xf "${download_path}" -C "${TEMP_DIR}"
    
    echo "Installing to ${INSTALL_DIR}..."
    mkdir -p "${INSTALL_DIR}" "${LIB_DIR}"
    
    mv "${TEMP_DIR}/bin/ollama" "${INSTALL_DIR}/ollama"
    
    if [[ -d "${TEMP_DIR}/lib" ]]; then
        mv "${TEMP_DIR}/lib/"* "${LIB_DIR}/" 2>/dev/null || true
    fi
    
    chmod +x "${INSTALL_DIR}/ollama"
    
    echo "✓ Ollama ${ollama_version} installed successfully"
    echo "  Binary: ${INSTALL_DIR}/ollama"
    echo "  Libraries: ${LIB_DIR}"
}

main "$@"