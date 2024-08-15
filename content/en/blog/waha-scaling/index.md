---
title: "WAHA Scaling - Vertical vs. Horizontal"
description: "WAHA Scaling - how to scale WAHA for >100 sessions with Vertical and Horizontal scaling"
excerpt: "WAHA Scaling - how to scale WAHA for >100 sessions with Vertical and Horizontal scaling"
date: 2024-08-14T08:48:45+00:00
draft: false
weight: 50
images: [ "horizontal-vs-vertical-scaling.png" ]
categories: [ "Tips" ]
tags: [ ]
contributors: [ "devlikeapro" ]
pinned: false
homepage: false
---

## Overview

The article is for people who want to scale their WhatsApp API for customers, like CRM, SaaS, or other services and
who needs to handle a lot (**>100**) of [**🖥️ Sessions**]({{< relref "/docs/how-to/sessions" >}}) (WhatsApp Accounts)

If you're using WAHA for **1-10** sessions - just make sure to follow
[**🔧 Install & Update**]({{< relref "/docs/how-to/install" >}}) guide.
It handles all the necessary steps to make it work.

## Vertical Scaling

![](waha-scaling-up.drawio.png)

**Vertical Scaling** is the process of adding more resources (CPU, RAM) to the single server to handle more sessions.

Assuming you've followed the guide [**🔧 Install & Update**]({{< relref "/docs/how-to/install" >}}) and
you got something like this architecture:

{{< img src="/images/waha/scaling/waha-vertical-scaling.drawio.png" >}}

**How many sessions you can run adding more resources (CPU and RAM) to the single WAHA server?**

Here's [approximate example how many session you can run on a single server](({{< relref "/docs/overview/faq#system-requirements" >}})) using **Vertical Scaling** approach:

| [**🏭 Engine**]({{< relref "/docs/how-to/engines" >}}) | Sessions | CPU   | Memory |
|:-------------------------------------------------------|----------|-------|--------|
| WEBJS                                                  | 50       | 1500% | 20GB   |
| NOWEB                                                  | 50       | 150%  | 4GB    |
| NOWEB                                                  | 500      | 300%  | 30GB   |

👉 The benchmark may differ from case to case, it depends on usage pattern - how many messages you get,
how many send, etc.

So if you need to run up to **50** session on **WEBJS** engine or up to **500** sessions on **NOWEB** - you 
can just keep adding more resources (CPU and RAM) to the single server! 
Fast to scale, easy to manage.🎉 

If you want to run more sessions - you need to consider **Horizontal Scaling**. 
It's not safe to run more than the above numbers on a single server!

## Horizontal Scaling - Sharding

![](waha-scaling-hor.drawio.png)

**Horizontal Scaling** is the process of adding more servers to handle more sessions.

{{< img src="/images/waha/scaling/waha-horizontal-scaling.drawio.png" >}}

### Entity Schema

### Where to run a new session?
tbd

### Where to find the session?
tbd


## Horizontal Scaling - Auto-Scaling
🚧🔨⏳ Auto-Scaling **IS NOT AVAILABLE** our of the box in WAHA yet! ⏳🔨🚧

We're working on it, but it's not ready yet, so we're just giving you a future vision how it will work.

The idea is to build **WAHA Hub** that will handle all API requests and distribute them to the **WAHA Workers** 
based on information where each session is running.

It'll also control (using underlying k8s or docker infrastructure) the number of workers based on the load.

{{< img src="/images/waha/scaling/waha-hub.png" >}}

Kindly [**support the project**]({{< relref "/pricing" >}}) on **PRO** tier if you wish to 
use the feature in the future! 🙏
