#!/bin/bash
atd && cron && apachectl -D BACKGROUND

$@