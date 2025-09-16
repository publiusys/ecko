#!/usr/bin/env python3

import logging
import subprocess

LOG_FILE_PATH = "power_consumption_info.log"


def main() -> None:
    logging.basicConfig(
            filename=LOG_FILE_PATH,
            filemode='a',
            format='%(asctime)s %(message)s',
            level=logging.INFO)

    logger = logging.getLogger()
    
    while True:
        try:
            result = subprocess.run(
                "sudo ipmitool sensor | grep Watts",
                shell=True,
                capture_output=True,
                check=True,
                text=True)
        
            logger.info(f"\n{result.stdout}")
        except Exception as err:
            logger.error(err.stderr)


if __name__ == '__main__':
    main()


