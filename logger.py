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
            result = subprocess.check_output(
                    ['sudo', 'ipmitool', 'sensor'],
                    text=True)
            
            for line in result.splitlines():
                if "Watts" in line:
                    logger.info(','.join([part.strip() for part in line.split("|")]))
        except Exception as err:
            logger.error(err.stderr)


if __name__ == '__main__':
    main()


