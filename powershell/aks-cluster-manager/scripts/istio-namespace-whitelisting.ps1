# Variables
$namespace = Read-Host "Enter the Istio Namespace"
$whitelistIps = Read-Host "Enter the IPs to whitelist (comma-separated)"

# Convert comma-separated IPs into an array
$ipsArray = $whitelistIps -split ','

# Create a whitelist network policy YAML
$networkPolicy = @"
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: whitelist-network-policy
  namespace: $namespace
spec:
  podSelector: {}
  ingress:
    - from:
        - ipBlock:
            cidr: $($ipsArray[0])/32
"@

# Append additional IPs to the network policy if any
for ($i = 1; $i -lt $ipsArray.Count; $i++) {
    $networkPolicy += @"
        - ipBlock:
            cidr: $($ipsArray[$i])/32
"@
}

$networkPolicy += @"
  policyTypes:
  - Ingress
"@

# Save the network policy to a YAML file
$networkPolicyPath = "$env:TEMP\whitelist-network-policy.yaml"
$networkPolicy | Out-File -FilePath $networkPolicyPath -Encoding utf8

# Apply the network policy using kubectl
kubectl apply -f $networkPolicyPath

# Output the result
Write-Host "Whitelist network policy has been applied to the namespace '$namespace'."

# Clean up the temporary YAML file
Remove-Item -Path $networkPolicyPath