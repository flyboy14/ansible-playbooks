#!/usr/bin/perl

$num_args = $#ARGV + 1;
if ($num_args != 2) {
    print "Usage: host_add.pl Name IP-address\n";
    exit;
}
use 5.010;
use strict;
use warnings;
use JSON::RPC::Client;
use Data::Dumper;

# Authenticate yourself
my $client = new JSON::RPC::Client;
my $url = 'http://192.168.33.12/zabbix/api_jsonrpc.php';
my $authID;
my $response;
my $hostName = $ARGV[0];
my $hostIP = $ARGV[1];

my $json = {
jsonrpc => "2.0",
method => "user.login",
params => {
user => "Admin",
password => "zabbix"
},
id => 1
};

$response = $client->call($url, $json);

# Check if response was successful
die "Authentication failed\n" unless $response->content->{'result'};

$authID = $response->content->{'result'};
print "Authentication successful. Auth ID: " . $authID . "\n";

# ---------

$json = {
jsonrpc => "2.0",
method => "host.create",
params => {
host => $hostName,
interfaces => [
{
type => 1,
main => 1,
useip => 1,
ip => $hostIP,
dns => "",
port => "10050"
}],
groups => [
{
groupid => "1"
}],
templates => [
{
templateid => "10001"
}],
inventory => {
macaddress_a => "01234",
macaddress_b => "56789"
}
},
id => 1,
auth => $authID
};
$response = $client->call($url, $json);

# Check if response was successful
die "Host creation failed somehow\n" unless $response->content->{'result'};

$authID = $response->content->{'result'};
print "Host creation successful. Host name: " . $hostName. "\n";
