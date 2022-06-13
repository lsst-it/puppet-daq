# daq

## Table of Contents

1. [Overview](#overview)
1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)

## Overview

Installs and configures LSST DAQ software.

## Description

This module installs the
[`daq-sdk`](https://repo-nexus.lsst.org/nexus/#browse/browse:daq:daq-sdk) and
[`rpt-sdk`](https://repo-nexus.lsst.org/nexus/#browse/browse:daq:rpt-sdk)
packages. It is also able to [optionally] manage the `dsid` and `rce` services.

## Usage

### Hiera Example

```yaml
---
classes:
  - "daq::daqsdk"
  - "daq::rptsdk"
  - "daq::service::dsid"
  - "daq::service::rce"

daq::daqsdk: "R5-V3.2"
daq::rptsdk: "3.5.3"
```

## Reference

See [REFERENCE](REFERENCE.md)
