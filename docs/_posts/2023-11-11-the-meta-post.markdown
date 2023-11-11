---
layout: post
title: "The meta post about how I build this blog"
date: 2023-11-11 00:00:00 +0000
categories: jekyll github pages blog
---

# Why am I building this blog?

I have been a professional software developer since 2011 and during all these years I have not only learned a lot of cool things related to the jobs I had. Obviously all that knowledge has been important in my career and it helps a lot in my day to day work. But I must say that I have struggled to find time to learn about new subjects that I find interesting or things that the industry in general is moving towards (like AI, large language models, etc).

My usual scenario when learning a new subject is this: I read about something in a blog post that sounds cool and interesting, I search for more information and other blog posts to have a better understanding of the subject. Suddenly, I get an idea of a cool project I can work where this new subject can be applied. I try to start working on it and a lot of activities of my day life get in the way leaving me without time to move forward in the project. I get frustrated and I leave the project for later. I forget about it and I start the cycle again with a new subject.

But the worst part is that during that process I learn a lot of things, find new blogs or people that knows a lot about many subjects that I like and as I don't keep track of anything more than a few abandoned projects I end up losing all that knowledge or forgetting about it.

This last thought made me realize that I need to start writing to myself of the future so I can have my own memories about things that I enjoy reading and maybe things I can work on when I have time. At least it shouldn't happen again that I lose all the things I learn and read in the process. Hopefully I can come back in the future and read about things that I was interested in the past and I can see how much I have learned since then. Moreover and as a major goal, I can finally end up working on some of those projects that I have been thinking about for a long time.

Although I have a lot of things I have read about this, the main blogs I usually read and that I found inspiring and with great ideas and posts are:

- https://simonwillison.net/
- https://adamj.eu/tech/

I wasn't able to find the blog posts that I was moslty inspired to write this blog, but one of them was [this](https://simonwillison.net/2022/Nov/6/what-to-blog-about/).

# What is this first post about?

The first thing to start writing is to have a place to do it. One can write into files, documents, etc and that will be fine. But in my experience, documentation in projects has always been a bit of a pain. I have always found it difficult to keep it up to date and to find the right place to put it. Also, not all the tools allows you to write technical documentation like code snippets so you end up with different tools for different things and that makes it easier to stop writing or to lose things.

Again, after reading a lot of blogs and people blogging for a lot of time, most of them have one common thought: it can be a pain if for some reason you decide to migrate your blog to another place or to use a different technology. So I decided to go with the simplest possible approach: write in simple markdown files.

Markdown is super simple and it is widely supported. It is also easy to maintain and as it is plain text, it is great to keep track using git. So I decided to go into that path and one of the tools around is Jekyll. Jekyll is a static site generator that allows you to write markdown files and it will generate a static website that you can host anywhere. It is also the tool that github pages uses to generate the websites for the repositories. So I decided to go with that.

# Steps to be online

## Initialize Jekyll

The first step is to initialize Jekyll. I decided to use docker to avoid installing anything in my computer. So I created a new folder to host the dockerfile and a docs folder to contain all Jekyll related files. I followed the steps here: https://jekyllrb.com/docs/ but ran them in Docker.

First thing was to move into the main folder and run these commands:

1. `docker run -it --rm --name jekyll -v ./docs:/srv/jekyll jekyll/jekyll bash`
   This will run a docker container based on jekyll/jekyll image. I mounted the docs folder into the workdir of the container so all the generated files would end up in my docs folder after removing the container.

2. `jekyll new --skip-bundle .`
   This command will create a new Jekyll project in the current folder. The parameter `--skip-bundle` is to avoid running `bundle install`. I will do it later since the jekyll user in the container doesn't have permissions to install gems. I will do it as root.

3. Then I entered the container as a root (using another terminal to avoid stopping the container) and ran :

- `bundle add webrick` because it is needed to serve jekyll since ruby 3.0.0 version
- `bundle install` to install all the dependencies and generate the Gemfile.lock file

4. Then I exited the container and created a Dockerfile and a docker-compose.yml file to make it easier to build and run locally the site.

## Customize the site

Jekyll creates a bunch of files with different information and content. I haven't had time yet to read about them and understand how to customize the theme and the site in general but that will be part of another post. I just want to concentrate in the main things and put the site online.

I just modified the about.markdown file and the \_config.yml file to add some information about the site and myself, removing the default values and text that Jekyll creates.
