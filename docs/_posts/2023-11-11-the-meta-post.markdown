---
layout: post
title: "How I built this blog"
date: 2023-11-11 00:00:00 +0000
categories: jekyll github pages blog
---

# Why am I building this blog?

# Steps to be online

- Follow steps in Jekyll website and in github pages
  `docker run -it --rm --name jekyll -v ./docs:/srv/jekyll jekyll/jekyll bash`
  `jekyll new --skip-bundle .`
  `bundle install`

- But also doing my own path to build it with docker
- Issues when trying to serve

```
Configuration file: /usr/src/app/_config.yml
            Source: /usr/src/app
       Destination: /usr/src/app/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
       Jekyll Feed: Generating feed for posts
                    done in 1.003 seconds.
 Auto-regeneration: enabled for '/usr/src/app'
                    ------------------------------------------------
      Jekyll 4.2.2   Please append `--trace` to the `serve` command
                     for any additional information or backtrace.
                    ------------------------------------------------
/usr/gem/gems/jekyll-4.2.2/lib/jekyll/commands/serve/servlet.rb:3:in `require': cannot load such file -- webrick (LoadError)
     from /usr/gem/gems/jekyll-4.2.2/lib/jekyll/commands/serve/servlet.rb:3:in `<top (required)>'
     from /usr/gem/gems/jekyll-4.2.2/lib/jekyll/commands/serve.rb:179:in `require_relative'
     from /usr/gem/gems/jekyll-4.2.2/lib/jekyll/commands/serve.rb:179:in `setup'
     from /usr/gem/gems/jekyll-4.2.2/lib/jekyll/commands/serve.rb:100:in `process'
     from /usr/gem/gems/jekyll-4.2.2/lib/jekyll/command.rb:91:in `block in process_with_graceful_fail'
     from /usr/gem/gems/jekyll-4.2.2/lib/jekyll/command.rb:91:in `each'
     from /usr/gem/gems/jekyll-4.2.2/lib/jekyll/command.rb:91:in `process_with_graceful_fail'
     from /usr/gem/gems/jekyll-4.2.2/lib/jekyll/commands/serve.rb:86:in `block (2 levels) in init_with_program'
     from /usr/gem/gems/mercenary-0.4.0/lib/mercenary/command.rb:221:in `block in execute'
     from /usr/gem/gems/mercenary-0.4.0/lib/mercenary/command.rb:221:in `each'
     from /usr/gem/gems/mercenary-0.4.0/lib/mercenary/command.rb:221:in `execute'
     from /usr/gem/gems/mercenary-0.4.0/lib/mercenary/program.rb:44:in `go'
     from /usr/gem/gems/mercenary-0.4.0/lib/mercenary.rb:21:in `program'
     from /usr/gem/gems/jekyll-4.2.2/exe/jekyll:15:in `<top (required)>'
     from /usr/local/bundle/bin/jekyll:27:in `load'
     from /usr/local/bundle/bin/jekyll:27:in `<main>'

```

- Configure github
- Try locally

{% highlight python %}
def my_blog():
print("Hello world")
{% endhighlight %}
