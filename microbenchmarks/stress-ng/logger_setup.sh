#!/bin/bash

function install_service()
{
	sudo cp logger.service /etc/systemd/system/
	sudo systemctl daemon-reload

	sudo systemctl status logger.service
}

function start_service()
{
	sudo systemctl start logger.service

	sudo systemctl status logger.service
}

function stop_service()
{
	sudo systemctl stop logger.service

	sudo systemctl status logger.service
}
