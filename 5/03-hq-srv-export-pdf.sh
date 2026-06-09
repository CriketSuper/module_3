#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${ENV_FILE:-$SCRIPT_DIR/.env}"

[[ -f "$ENV_FILE" ]] || {
    echo "ERROR: $ENV_FILE not found" >&2
    exit 1
}

# shellcheck disable=SC1090
source "$ENV_FILE"

NFS_EXPORT_DIR="${NFS_EXPORT_DIR:-/raid/nfs}"
EXPORTED_PDF_NAME="${EXPORTED_PDF_NAME:-Print.pdf}"
EXPORTED_PDF_MODE="${EXPORTED_PDF_MODE:-0666}"
PDF_WAIT_SECONDS="${PDF_WAIT_SECONDS:-30}"

log() {
    printf '[HQ-SRV PDF export] %s\n' "$*"
}

die() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

[[ $EUID -eq 0 ]] || die "run this script as root"
[[ -d "$NFS_EXPORT_DIR" ]] ||
    die "$NFS_EXPORT_DIR does not exist; configure RAID and NFS first"
[[ "$PDF_WAIT_SECONDS" =~ ^[0-9]+$ ]] ||
    die "PDF_WAIT_SECONDS must be numeric"

find_latest_pdf() {
    local -a search_roots=()
    local path

    shopt -s nullglob
    for path in /var/spool/cups-pdf /home/*/PDF /root/PDF; do
        [[ -d "$path" ]] && search_roots+=("$path")
    done
    shopt -u nullglob

    ((${#search_roots[@]} > 0)) || return 1

    find "${search_roots[@]}" \
        -type f -iname '*.pdf' -printf '%T@ %p\n' 2>/dev/null |
        sort -nr |
        head -n 1 |
        cut -d' ' -f2-
}

log "Waiting for a generated PDF"
latest_pdf=""
for ((second = 0; second <= PDF_WAIT_SECONDS; second++)); do
    latest_pdf="$(find_latest_pdf || true)"
    [[ -n "$latest_pdf" ]] && break
    sleep 1
done

[[ -n "$latest_pdf" ]] ||
    die "no PDF found in the cups-pdf output directories"

destination="$NFS_EXPORT_DIR/$EXPORTED_PDF_NAME"
install -m "$EXPORTED_PDF_MODE" "$latest_pdf" "$destination"

log "Exported $latest_pdf to $destination"
ls -l "$destination"
