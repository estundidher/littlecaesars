./drop_and_create_development.sh
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U caesars -d caesars_development $1
echo 'caesars_development restored..'
