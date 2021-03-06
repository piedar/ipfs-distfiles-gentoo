#!/bin/bash

set -x


distdir_tmp=$(mktemp --directory)
trap 'rm -r "${distdir_tmp}"' EXIT

DISTDIR_TMP="${DISTDIR_TMP:-${distdir_tmp}}"
DISTDIR="${DISTDIR:-/usr/portage/distfiles}"

package="$@"

DISTDIR="${DISTDIR_TMP}"                      emerge --fetchonly "${package}" || exit $?
DISTDIR="${DISTDIR_TMP}" ACCEPT_KEYWORDS="~*" emerge --fetchonly "${package}"


added_files=()

for file in "${DISTDIR_TMP}"/* ; do
  [[ -f "${file}" ]] || continue

  filename=$(basename ${file})
  hash=$(ipfs add "${file}" --quiet --progress) || continue

  cd "${DISTDIR}"
  target_file="${DISTDIR}/${filename}"

  rm -f "${filename}"
  ln -s "/ipfs/${hash}" "${filename}"
  git add "${filename}" || exit $?
  added_files+=("${filename}")
done

git commit ${added_files[@]} -m "link ${package}"
