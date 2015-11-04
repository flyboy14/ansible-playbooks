#!/usr/bin/perl

# (1) quit unless we have the correct number of command-line args
$num_args = $#ARGV + 1;
if ($num_args != 2) {
    print "Usage: host_status.pl HostID Status\n";
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
method => 'host.update',
params =>
{
hostid => "$HostID",
status => $ARGV[1]
},
id => 1,
auth => "$authID",
};
$response = $client->call($url, $json);

# Check if response was successful
die "host.update failed somehow\n" unless $response->content->{result};

print "Updated Host with ID: ".$HostID. " status to ".$ARGV[1]."\n";
