. secrets/env.sh
bundle update
rake assets:precompile
bundle exec puma -e production -b unix:///web/everything-about-here/shared/sockets/puma.sock -d
