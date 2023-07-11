# Basics of Networking

Each item connected to the network has its own IP address. The IP address,
is given to the item by the router. Think of the router as the access and
exit point for all things outside of your network. Withing your network, all
items have a similar IP address. This is because the IP address is \*unique to
the network.

### IP Address, Subnet Mask, and Default Gateway

An IP Address is 32 bits long. It has a structure similar to the one shown below:

> 192.168.0.1

In the example above, we can see there are 4 numbers, each separated by a dot.
How does this relate to the 32 bits defined above? The relationship is that each
number is in between 0 and 255 or 1 byte.

The Subnet Mask has a similar structure as the IP Address:

> 255.255.255.0

Even though it also contains 4 numbers each 1 byte long. The numbers can only be
either 0 or 255. This is because the Subnet Mask acts as a constraint to the router
to which IP Addresses it can assign to items in the network. To further illustrate:

```
IP Address:    192.168.0.1
Subnet Mask:   255.255.255.0
```

If the number of the Subnet Mask is 255 it states that the equivalent IP number
is FIXED, if the Subnet Mask number is 0 the equivalent IP is not FIXED. Therefore
since in the example above, the last number of the Subnet Mask is 0, the router,
can assign 253 IP Addresses.

> It is 254 because 0 is reserved, 1 is the router IP address, and 255 it the broadcast IP.

In combination with the IP address and the Subnet Mask we can determine our
local network. This is because the Subnet Mask is a constraint to the size
of our network. In the example above, we know that `192.168.0` is FIXED. Therefore,
it represents out local IP Address.

The default Gateway is another name for the router, since the router communicates
with the outside world, each item in the network knows the default gateway address.
If an item wants to communicate with the outside world it relays its communication
though the router.

### Layers: L1, L2, L3, L4, L7

The layers represent different layers of communication between items in a network.

- L1 Physical Layer: Represents physical connections, think of wires and cables.
- L2 Data Link Layer: Represents MAC-Addresses, each item in a network has an IP and a MAC address.
  The MAC address is like the ID of the thing, while the IP is handed by the router.
- L3 Network Layer: Represents the IP Address.
- L4 Transport Layer: Represents the Transport of Data either TCP or UDP (TCP = reliable; UDP fire and forget).
- L7 Application Layer: Think the application from which the request is launched, browser, email, etc.

### Ports, Switches, and Routers.

Ports and Cables only know about L1.
Switches only know about L2.
Routers only know about L3.

Ports connect directly to the machine and the switch.
Switches direct traffic to the items specific MAC Address (it knows nothing about IP).
Routers know IP, as it is how networks communicate.

### Ports

Ports are simple, just the physical communication between the switch and machine.

### Switches

As mentioned above, switches only understand L2: MAC-Addresses. Therefore, how
does communication work in a network as machines in a network communicate
though their IP Addresses (L3)? The answer is ARP (Address-resolution-protocol).
Since a switch does not understand L3 it needs to find a way to communicate using
MAC-Addresses, the role of the ARP is to broadcast all items in the network
if they are XXX.XXX.XXX.XXX IP. If the item is indeed the IP address requested,
it responds, the switch saves the MAC-Address that belongs to that IP and therefore,
remembers that IP X belongs to MAC-Addresses Y.

### Router

If a machine requests something from another network. The item knows that the request
is from another network because it compares the request IP to the current IP and
Subnet Mask. To illustrate:

```
Local IP:    192.168.0.3
Subnet Mask: 255.255.255.0
Req IP:      318.023.234.21
```

Since the FIXED numbers do not match, the machine determines the request
should go to the Default Gateway a.k.a. router.

> Importantly, Layers 2 and 3 store the destination and the requester IP / MAC Address.
