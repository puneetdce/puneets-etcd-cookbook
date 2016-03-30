#!/usr/bin/ruby
require 'httparty'

url= "http://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem"
response = HTTParty.get(url)
cert = response.code = 200 ? response.body : nil

etcd_service 'default' do
  action [:create, :start]
end

etcd_key '/test' do
  value 'a_test_value'
end

etcd_key '/foo' do
  value cert
end

execute 'etcdctl set /delete delete' do
  not_if { ::File.exist?('/marker_etcd_key_delete') }
end

file '/marker_etcd_key_delete' do
  action :create
end

etcd_key '/delete' do
  action :delete
end
