#!/bin/bash -e
DEST=$PWD

mkdir .tmp || true
cd .tmp
git clone https://github.com/svaarala/duktape.git
cd duktape
git checkout tags/v2.3.0

# you might have to install the python yaml package:
# pip install pyyaml

python2 ./tools/configure.py \
    --output-directory ./output \
    --source-directory src-input \
    --config-metadata config \
    --emit-legacy-feature-check \
    --git-branch master \
    --line-directives \
    -UDUK_USE_REFLECT_BUILTIN

cp output/* $DEST

# copy extras
cp extras/alloc-pool/duk_alloc_pool.c $DEST
cp extras/alloc-pool/duk_alloc_pool.h $DEST
cp extras/console/duk_console.c $DEST
cp extras/console/duk_console.h $DEST
cp extras/duk-v1-compat/duk_v1_compat.c $DEST
cp extras/duk-v1-compat/duk_v1_compat.h $DEST
cp extras/logging/duk_logging.c $DEST
cp extras/logging/duk_logging.h $DEST
cp extras/print-alert/duk_print_alert.c $DEST
cp extras/print-alert/duk_print_alert.h $DEST
cp extras/module-duktape/duk_module_duktape.c $DEST
cp extras/module-duktape/duk_module_duktape.h $DEST
cp extras/module-node/duk_module_node.c $DEST
cp extras/module-node/duk_module_node.h $DEST
cp extras/minimal-printf/duk_minimal_printf.c $DEST
cp extras/minimal-printf/duk_minimal_printf.h $DEST
