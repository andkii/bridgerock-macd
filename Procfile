web:		bundle exec rails server -p $PORT
worker:	env TERM_CHILD=1 bundle exec rake resque:work QUEUE='*'
clock:	bundle exec clockwork lib/clock.rb
redis:	redis-server