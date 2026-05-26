import pulumi
import pulumi_aws as aws

# Ein Array von Namen – geladen aus einer Konfiguration oder hartcodiert
server_names = ["web-prod", "web-stage"]

# Schleifen und native Logik sind direkt verfügbar
for name in server_names:
    server = aws.ec2.Instance(
        name,
        instance_type="t3.micro",
        ami="ami-0c55b159cbfafe1f0",
        tags={"Name": name}
    )

# Exportieren von Werten für andere Stacks
pulumi.export("last_server_id", server.id)