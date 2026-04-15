#!/bin/bash

rm -rf public
hugo

ssh -p 65002 u254462768@195.35.38.198 "rm -rf /home/u254462768/domains/itmt-prof.com/public_html/docker/*"
scp -rP 65002 public/* u254462768@195.35.38.198:public_html/docker/