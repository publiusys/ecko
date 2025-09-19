#!/usr/bin/env python3

import logging
from logging import Logger
import asyncio

LOG_FILE_PATH = "power_consumption_info.log"


async def log_ipmisensor(logger : Logger) -> None:
    """Continuously log the output of ipmitool sensor"""
    while True:
        try:
            proc = await asyncio.create_subprocess_shell(
                    "sudo ipmitool sensor",
                     stdout=asyncio.subprocess.PIPE,
                     stderr=asyncio.subprocess.PIPE)

            stdout, stderr = await proc.communicate()

            for line in stdout.splitlines():
                if "Watts" in line:
                    logger.info(','.join([part.strip() for part in line.split("|")]))
        except Exception as err:
            logger.error(err)


#async def log_perfsensor(logger : Logger) -> None:
#    """Continuously log the output of perf sensor"""
#    pass


async def async_main() -> None:
    logging.basicConfig(
            filename=LOG_FILE_PATH,
            filemode='a',
            format='%(asctime)s,%(message)s',
            datefmt="%Y-%m-%d %H:%M:%S",
            level=logging.INFO)

    logger = logging.getLogger()

    await asyncio.gather(
            log_ipmisensor(logger))


def main() -> None:
    asyncio.run(async_main())


if __name__ == '__main__':
    main()


