#!/bin/sh
ip="$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' app-mandatendatabank_export_1)"
curl -X POST http://$ip/export-tasks