document.write("****Test Case 2****<BR>")
Dim testCase2
Dim expectedGCD_testCase2
Dim actualGCD_testCase2

expectedGCD_testCase2 = 1
actualGCD_testCase2 = SilverChallenge(Array(142341, 512345))
document.write("Expected GCD: "& expectedGCD_testCase2 &"<BR>")
document.write("Actual GCD:"&actualGCD_testCase2&"<BR>")

If actualGCD_testCase2 = expectedGCD_testCase2 Then
	document.write("<font color=""green"">PASS</font><BR>")
Else
	document.write("<font color=""red"">FAIL</font><BR>")
End If
document.write("*****************")