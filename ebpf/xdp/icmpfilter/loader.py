#!/usr/bin/env python3

from bcc import BPF
import argparse


def load_xdpfilter(device):
    b = BPF(src_file="filter.c")
    fn = b.load_func("icmpfilter", BPF.XDP)
    b.attach_xdp(device, fn, 0)
    return b


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "device", help="network device where to attach the xdp program", type=str
    )
    args = parser.parse_args()
    print(f"Attaching the xdp program to {args.device}")
    b = load_xdpfilter(args.device)

    try:
        b.trace_print()
    except KeyboardInterrupt:
        print("Interrupted by the keyboard. Cleaning up")

    b.remove_xdp(args.device, 0)
