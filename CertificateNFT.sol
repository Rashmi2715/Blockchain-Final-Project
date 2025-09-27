// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CertificateNFT {
    struct Certificate {
        string employeeName;
        string employeeId; // Unique identifier (could be email or username)
        string companyName;
        string jobRole;
        string skills;
        string performance;
        uint256 dateIssued;
        uint256 experienceYears; // Calculated based on joining and completing years
        uint256 joiningYear; // Year the employee joined
        uint256 completingYear; // Year the employee completed or finished the role
    }

    Certificate[] public certificates;

    // Map employeeId to certificate IDs
    mapping(string => uint256[]) private certificatesOfEmployee;

    event CertificateIssued(uint256 id, string employeeId);

    // Issue a certificate to an employee
    function issueCertificate(
        string memory _employeeName,
        string memory _employeeId,
        string memory _companyName,
        string memory _jobRole,
        string memory _skills,
        string memory _performance,
        uint256 _joiningYear,  // Joining year of the employee
        uint256 _completingYear // Completing year of the employee
    ) public returns (uint256) {
        // Calculate experience years as the difference between completingYear and joiningYear
        uint256 experienceYears = _completingYear - _joiningYear;

        Certificate memory newCert = Certificate(
            _employeeName,
            _employeeId,
            _companyName,
            _jobRole,
            _skills,
            _performance,
            block.timestamp,
            experienceYears, // Store the calculated experience years
            _joiningYear,
            _completingYear
        );
        certificates.push(newCert);
        uint256 certId = certificates.length - 1;
        certificatesOfEmployee[_employeeId].push(certId); // Link cert to employee

        emit CertificateIssued(certId, _employeeId);
        return certId;
    }

    // Get certificate details by ID
    function getCertificate(uint256 id) public view returns (
        string memory, string memory, string memory, string memory, string memory, string memory, uint256, uint256, uint256, uint256
    ) {
        Certificate memory cert = certificates[id];
        return (
            cert.employeeName,
            cert.employeeId,
            cert.companyName,
            cert.jobRole,
            cert.skills,
            cert.performance,
            cert.dateIssued,
            cert.experienceYears, // Return the calculated experience years
            cert.joiningYear, // Return the joining year
            cert.completingYear // Return the completing year
        );
    }

    // Get all certificates for a specific employee
    function getCertificatesOf(string memory _employeeId) public view returns (uint256[] memory) {
        return certificatesOfEmployee[_employeeId];
    }

    // Total number of certificates
    function totalCertificates() public view returns (uint256) {
        return certificates.length;
    }
}