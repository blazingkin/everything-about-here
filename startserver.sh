. secrets/env.sh
rake assets:precompile
bundle exec puma -e production -b unix:///web/everything-about-here/shared/sockets/puma.sock -d
