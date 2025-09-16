#!/usr/bin/env python3

import logging
import subprocess


def main() -> None:
    logging.basicConfig(
            filename="info.log",
            filemode='w',
            format='%(asctime)s %(message)s',
            level=logging.INFO)

    logger = logging.getLogger()

    try:
        result = subprocess.run(
            "sudo ipmitool sensor | grep Watts",
            shell=True,
            capture_output=True,
            check=True,
            text=True)
        
        logger.info(f"\n{result.stdout}\n")
    except Exception as err:
        logger.error(err.stderr)


if __name__ == '__main__':
    main()


