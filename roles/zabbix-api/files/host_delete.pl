#!/usr/bin/perl

# (1) quit unless we have the correct number of command-line args
$num_args = $#ARGV + 1;
if ($num_args != 1) {
    print "Usage: host_delete.pl HostID\n";
    exit;
}
print "Deleting host with id ".$ARGV[0].".\n";
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
my $HostID = $ARGV[0];

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

# Get list of all hosts using authID

$json = {
jsonrpc=> '2.0',
method => 'host.delete',
params =>
{
hostid => "$HostID"
},
id => 1,
auth => "$authID",
};
$response = $client->call($url, $json);

# Check if response was successful
die "host.delete failed somehow\n" unless $response->content->{result};

print "Deleted Host with ID: ".$HostID. ".\n";
