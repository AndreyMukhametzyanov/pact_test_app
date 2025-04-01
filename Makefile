.PHONY: .check
.check: bundle audit brakeman rspec

.PHONY: check
check:
	make .check --keep-going

.PHONY: bundle
bundle:
	bundle install

.PHONY: db
db:
	bundle exec rails db:create RAILS_ENV=development
	bundle exec rails db:migrate RAILS_ENV=development
	bundle exec rails db:create RAILS_ENV=test
	bundle exec rails db:migrate RAILS_ENV=test
	bundle exec rails db:seed RAILS_ENV=development
	bundle exec rails db:seed RAILS_ENV=test

.PHONY: audit
audit:
	bundle exec bundle-audit check --update
	bundle exec bundler-leak check --update

.PHONY: brakeman
brakeman:
	bundle exec brakeman --run-all-checks --force-scan --no-pager

.PHONY: rubocop
rubocop:
	bundle exec rubocop

.PHONY: rspec
rspec:
	bundle exec rspec
