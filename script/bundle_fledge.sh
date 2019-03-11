#!/usr/bin/env bash

# script to bundle all the CI/CD-specific code developed in example app
# for delivery via Fledge

cd example
tar cfzv ../lib/resource/fastlane/fastlane.tar.gz fastlane android/fastlane ios/fastlane script Gemfile*
