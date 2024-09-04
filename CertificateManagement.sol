// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// Importando Ownable de OpenZeppelin
import "@openzeppelin/contracts/access/Ownable.sol";

contract CertificateManagement is Ownable {
    
    uint counter = 0;

    struct Certificate {
        uint id;
        string name;
        string course;
        uint issueDate;
    }

    Certificate[] public certificates;

    event CertificateIssued(uint id, string name, string course, uint issueDate);

    constructor () Ownable(msg.sender) {}

    function issuedCertificate (string memory _name, string memory _course ) public onlyOwner {
        uint _timestamp = block.timestamp;
        certificates.push(Certificate(counter, _name, _course, _timestamp));
        emit CertificateIssued(counter, _name, _course, _timestamp);
        counter++;
    }

    function getAllCertificates(bool ascending) public view returns (Certificate[] memory) {
        Certificate[] memory sortedCertificates = certificates;

        // Ordenar los certificados según issueDate
        for (uint i = 0; i < sortedCertificates.length - 1; i++) {
            for (uint j = i + 1; j < sortedCertificates.length; j++) {
                if (ascending) {
                    // Orden ascendente
                    if (sortedCertificates[i].issueDate > sortedCertificates[j].issueDate) {
                        // Intercambiar posiciones
                        Certificate memory temp = sortedCertificates[i];
                        sortedCertificates[i] = sortedCertificates[j];
                        sortedCertificates[j] = temp;
                    }
                } else {
                    // Orden descendente
                    if (sortedCertificates[i].issueDate < sortedCertificates[j].issueDate) {
                        // Intercambiar posiciones
                        Certificate memory temp = sortedCertificates[i];
                        sortedCertificates[i] = sortedCertificates[j];
                        sortedCertificates[j] = temp;
                    }
                }
            }
        }

        return sortedCertificates;
    }

    // Función para filtrar certificados por año
    function getCertificatesByYear(uint _year) public view returns (Certificate[] memory) {
        uint startTimestamp = toUnixTimestamp(_year, 1, 1);  // 1 de enero del año _year
        uint endTimestamp = toUnixTimestamp(_year + 1, 1, 1) - 1;  // 31 de diciembre del año _year

        // Crear un array temporal con tamaño máximo igual al total de certificados
        Certificate[] memory tempCertificates = new Certificate[](certificates.length);
        uint index = 0;

        // Filtrar y almacenar los certificados que estén en el rango
        for (uint i = 0; i < certificates.length; i++) {
            if (certificates[i].issueDate >= startTimestamp && certificates[i].issueDate <= endTimestamp) {
                tempCertificates[index] = certificates[i];
                index++;
            }
        }

        // Crear un array de tamaño exacto con los certificados filtrados
        Certificate[] memory filteredCertificates = new Certificate[](index);
        for (uint i = 0; i < index; i++) {
            filteredCertificates[i] = tempCertificates[i];
        }

        return filteredCertificates;
    }

    // Función auxiliar para convertir una fecha en año, mes, día a un timestamp Unix
    function toUnixTimestamp(uint year, uint month, uint day) internal pure returns (uint timestamp) {
        return (year - 1970) * 365 * 24 * 60 * 60 + (month - 1) * 30 * 24 * 60 * 60 + (day - 1) * 24 * 60 * 60;
    }

    // Función para verificar si un certificado existe por su ID
    function verifyCertificate(uint _id) public view returns (bool) {
        for (uint i = 0; i < certificates.length; i++) {
            if (certificates[i].id == _id) {
                return true;  // Certificado encontrado
            }
        }
        return false;  // Certificado no encontrado
    }

}
