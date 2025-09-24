#!/usr/bin/env python3

import logging
from logging import Logger
import asyncio
from datetime import datetime


async def log_ipmisensor(logger : Logger) -> None:
    """Continuously log the output of ipmitool sensor"""
    while True:
        try:
            cmd = "sudo ipmitool sensor"

            proc = await asyncio.create_subprocess_shell(
                    cmd,
                    stdout=asyncio.subprocess.PIPE,
                    stderr=asyncio.subprocess.PIPE)

            stdout, stderr = await proc.communicate()

            for line in stdout.decode().splitlines():
                if "Watts" in line:
                    logger.info(','.join([part.strip() for part in line.split("|")]))
        except Exception as err:
            logger.error(err)


async def log_perfsensor(logger : Logger) -> None:
    """Continuously log the output of perf sensor"""
    cmd = (
        "sudo perf stat -a "
        "-e instructions,cache-misses,ref-cycles,power/energy-pkg/,power/energy-ram/ "
        "-x, -I 1000")

    proc = await asyncio.create_subprocess_shell(
        cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE)

    try:
        while True:
            line = await proc.stderr.readline()

            if not line:
                break

            line_text = line.decode().strip()

            if line_text:
                logger.info(line_text)
    except Exception as err:
        logger.error(err)


async def async_main() -> None:
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")

    ipmisensor_logger = init_logger(
            "ipmisensor",
            f"ipmi{timestamp}.log")

    perfsensor_logger = init_logger(
            "perfsensor",
            f"perf{timestamp}.log")

    await asyncio.gather(
            log_ipmisensor(ipmisensor_logger),
            log_perfsensor(perfsensor_logger))


def init_logger(
        name : str,
        file_path : str,
        level=logging.INFO,
        date_format : str = "%Y-%m-%d %H:%M:%S") -> Logger:
    """Function for creating new Logger objects
    https://stackoverflow.com/questions/11232230/logging-to-two-files-with-different-settings"""

    formatter = logging.Formatter(
        '%(asctime)s,%(message)s',
        datefmt=date_format)

    handler = logging.FileHandler(file_path)        
    handler.setFormatter(formatter)

    logger = logging.getLogger(name)
    logger.setLevel(level)
    logger.addHandler(handler)

    return logger


def main() -> None:
    asyncio.run(async_main())


if __name__ == '__main__':
    main()


