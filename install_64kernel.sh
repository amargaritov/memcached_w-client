#!/bin/bash -x 

mkdir temp

cp linux_64kb.tar.bz2 temp/

pushd temp
tar xvjf linux_64kb.tar.bz2

pushd kernel_64kb
sudo dpkg -i linux-*
