#!/bin/bash

set -x


distdir_tmp=$(mktemp --directory)
trap 'rm -r "${distdir_tmp}"' EXIT

DISTDIR_TMP="${DISTDIR_TMP:-${distdir_tmp}}"
DISTDIR="${DISTDIR:-/usr/portage/distfiles}"

DISTDIR="${DISTDIR_TMP}" emerge --quiet --fetchonly "${1}" >> /dev/null || exit $?

for file in "${DISTDIR_TMP}"/* ; do
	filename=$(basename ${file})
  hash=$(ipfs add "${file}" --quiet --progress) || continue

  cd "${DISTDIR}"
  target_file="${DISTDIR}/${filename}"
  rm -f "${filename}"
  ln -s "/ipfs/${hash}" "${filename}"
  git add "${filename}"
  git commit "${filename}" -m "link ${filename}"
done
