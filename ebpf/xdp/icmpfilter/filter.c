
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>

/*
	Filter out ICMP packets. It only works for the ipv4 stack
*/
int icmpfilter(struct xdp_md *ctx) {
 	void *data = (void *)(long)ctx->data;
  	void *data_end = (void *)(long)ctx->data_end;
  	struct ethhdr *eth = data;
  
	if ((void*)eth + sizeof(*eth) <= data_end) {
    		struct iphdr *ip = data + sizeof(*eth);
    		if ((void*)ip + sizeof(*ip) <= data_end) {
      			if (ip->protocol == IPPROTO_ICMP) {
       				bpf_trace_printk("Dropping ICMP packet\n"); 
       				return XDP_DROP;
      			}
    		}
  	}
  
	bpf_trace_printk("Packet not dropped\n");
  	return XDP_PASS;
}

