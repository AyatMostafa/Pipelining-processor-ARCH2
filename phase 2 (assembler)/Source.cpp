#include<iostream>
#include<vector>
#include<string>
#include<fstream>
#include<ostream>
#include <unordered_map>
#include<bitset>
using namespace std;
unordered_map <string, string> opcodes;
unordered_map <string, string> registers;
vector<string> binary_code(4096);
int address = 0;
string file_name;
void assign_opcodes_and_reg() {
	//2 operand operations
	opcodes["SWAP"] = "0000000";
	opcodes["ADD"] = "0000001";
	opcodes["IADD"] = "0000010";
	opcodes["SUB"] = "0000011";
	opcodes["AND"] = "0000100";
	opcodes["OR"] = "0000101";
	opcodes["SHL"] = "0000110";
	opcodes["SHR"] = "0000111";
	//-----------------------------
	//1 op operations
	opcodes["NOP"] = "0001000000000000";
	opcodes["NOT"] = "0001001";
	opcodes["INC"] = "0001010";
	opcodes["DEC"] = "0001011";
	opcodes["OUT"] = "0001100";
	opcodes["IN"] = "0001101";
	//----------------------------
	//branch and input signal
	opcodes["JZ"] = "0010000";
	opcodes["JMP"] = "0010001";
	opcodes["CALL"] = "0010010";
	opcodes["RET"] = "0010100000000000";
	opcodes["RTI"] = "0010101000000000";
	opcodes["RESET"] = "0010110000000000";
	opcodes["INTERRUPT"] = "0010111000000000";
	//------------------------------
	//memory operations
	opcodes["PUSH"] = "0011000";
	opcodes["POP"] = "0011001000000";
	opcodes["LDM"] = "0011100000000";
	opcodes["LDD"] = "0011101000000";
	opcodes["STD"] = "0011110";
	//------------------------------
	// reg codes
	registers["R0"] = "000";
	registers["R1"] = "001";
	registers["R2"] = "010";
	registers["R3"] = "011";
	registers["R4"] = "100";
	registers["R5"] = "101";
	registers["R6"] = "110";
	registers["R7"] = "111";

}

//---------------convert from hex to decimal---------------
long long hex2dec(string hex)
{
	long long result = 0;
	for (int i = 0; i < hex.length(); i++) {
		if (hex[i] >= 48 && hex[i] <= 57)
		{
			result += (hex[i] - 48)*pow(16, hex.length() - i - 1);
		}
		else if (hex[i] >= 65 && hex[i] <= 70) {
			result += (hex[i] - 55)*pow(16, hex.length() - i - 1);
		}
		else if (hex[i] >= 97 && hex[i] <= 102) {
			result += (hex[i] - 87)*pow(16, hex.length() - i - 1);
		}
	}
	return result;
}
//----------------------get what's the operation and its position-------
int is_one_operand(string operation) {
	if (operation == "NOP") {
		return 1;
	}
	else if (operation == "NOT") {
		return 2;
	}
	else if (operation == "INC") {
		return 3;
	}
	else if (operation == "DEC") {
		return 4;
	}
	else if (operation == "OUT") {
		return 5;
	}
	else if (operation == "IN") {
		return 6;
	}
	return -1;
}

int is_two_operand(string operation) {
	if (operation == "SWAP") {
		return 1;
	}
	else if (operation == "ADD") {
		return 2;
	}
	else if (operation == "IADD") {
		return 3;
	}
	else if (operation == "SUB") {
		return 4;
	}
	else if (operation == "AND") {
		return 5;
	}
	else if (operation == "OR") {
		return 6;
	}
	else if (operation == "SHL") {
		return 7;
	}
	else if (operation == "SHR") {
		return 8;
	}
	return -1;
}

int is_memory_operation(string operation) {
	if (operation == "PUSH") {
		return 1;
	}
	else if (operation == "POP") {
		return 2;
	}
	else if (operation == "LDM") {
		return 3;
	}
	else if (operation == "LDD") {
		return 4;
	}
	else if (operation == "STD") {
		return 5;
	}
	return -1;
}

int is_branch_and_change_operation(string operation) {
	if (operation == "JZ") {
		return 1;
	}
	else if (operation == "JMP") {
		return 2;
	}
	else if (operation == "CALL") {
		return 3;
	}
	else if (operation == "RET") {
		return 4;
	}
	else if (operation == "RTI") {
		return 5;
	}
	return -1;
}

int is_input_signal_operand(string operation) {
	if (operation == "RESET") {
		return 1;
	}
	else if (operation == "INTERRUPT") {
		return 2;
	}
	return -1;
}
//------------------------------------------------
//process opeartions
void process_one_operand(string line, int position) {
	string code = "";
	if (position == 1) {
		code += opcodes["NOP"];
	}
	else if (position == 2) {
		code += opcodes["NOT"];
		for (int i = 0;i < line.size();++i) {
			if (line[i] == 'R') {
				string reg = "";
				reg += line[i]; reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000";
				code += registers[reg];
				break;
			}
		}
	}
	else if (position == 3) {
		code += opcodes["INC"];
		for (int i = 0;i < line.size();++i) {
			if (line[i] == 'R') {
				string reg = "";
				reg += line[i]; reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000";
				code += registers[reg];
				break;
			}
		}
	}
	else if (position == 4) {
		code += opcodes["DEC"];
		for (int i = 0;i < line.size();++i) {
			if (line[i] == 'R') {
				string reg = "";
				reg += line[i]; reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000";
				code += registers[reg];
				break;
			}
		}
	}
	else if (position == 5) {
		code += opcodes["OUT"];
		for (int i = 0;i < line.size();++i) {
			if (line[i] == 'R') {
				string reg = "";
				reg += line[i]; reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000";
				code += registers[reg];
				break;
			}
		}
	}
	else {
		code += opcodes["IN"];
		for (int i = 0;i < line.size();++i) {
			if (line[i] == 'R') {
				string reg = "";
				reg += line[i]; reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000";
				code += registers[reg];
				break;
			}
		}
	}
	binary_code[address++] = code;
}
//-------------
void process_two_operand(string line, int position) {
	string code = "";
	if (position == 1) {
		code += opcodes["SWAP"];
		bool comma_first_place = 0;
		for (int i = 4;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += registers[reg];
				break;
			}
		}
		binary_code[address++] = code;
	}
	else if (position == 2) {
		code += opcodes["ADD"];
		bool comma_first_place = 0;
		bool comma_second_place = 0;
		for (int i = 3;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && !comma_second_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (!comma_second_place && comma_first_place && line[i] == ',') {
				comma_second_place = 1;
			}
			else if (!comma_second_place && comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (comma_second_place && comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				break;
			}
		}
		binary_code[address++] = code;
	}
	else if (position == 3) {
		code += opcodes["IADD"];
		string immediate = "";
		bool comma_first_place = 0;
		bool comma_second_place = 0;
		for (int i = 3;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && !comma_second_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000";
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (!comma_second_place && comma_first_place && line[i] == ',') {
				comma_second_place = 1;
			}
			else if (!comma_second_place && comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (comma_second_place && comma_first_place && (isdigit(line[i]) || line[i] == 'A' || line[i] == 'B' || line[i] == 'C' || line[i] == 'D' || line[i] == 'E' || line[i] == 'F')) {  //---------------------------
				immediate += line[i];
			}
			else if (comma_second_place && comma_first_place && isalpha(line[i])) {
				cout << "error, the " << line[i] << " not a hex value in " << line << endl;
				system("pause");
				exit(0);
			}
		}
		binary_code[address++] = code;
		int result = hex2dec(immediate);
		binary_code[address++] = bitset<16>(result).to_string();
	}
	else if (position == 4) {
		code += opcodes["SUB"];
		bool comma_first_place = 0;
		bool comma_second_place = 0;
		for (int i = 3;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && !comma_second_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (!comma_second_place && comma_first_place && line[i] == ',') {
				comma_second_place = 1;
			}
			else if (!comma_second_place && comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (comma_second_place && comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				break;
			}
		}
		binary_code[address++] = code;
	}
	else if (position == 5) {
		code += opcodes["AND"];
		bool comma_first_place = 0;
		bool comma_second_place = 0;
		for (int i = 3;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && !comma_second_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (!comma_second_place && comma_first_place && line[i] == ',') {
				comma_second_place = 1;
			}
			else if (!comma_second_place && comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (comma_second_place && comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				code += registers[reg];
				break;
			}
		}
		binary_code[address++] = code;
	}
	else if (position == 6) {
		code += opcodes["OR"];
		bool comma_first_place = 0;
		bool comma_second_place = 0;
		for (int i = 3;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && !comma_second_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (!comma_second_place && comma_first_place && line[i] == ',') {
				comma_second_place = 1;
			}
			else if (!comma_second_place && comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (comma_second_place && comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				break;
			}
		}
		binary_code[address++] = code;
	}
	else if (position == 7) {
		code += opcodes["SHL"];
		string immediate = "";
		bool comma_first_place = 0;
		for (int i = 3;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000";
				code += registers[reg];
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (comma_first_place && (isdigit(line[i]) || line[i] == 'A' || line[i] == 'B' || line[i] == 'C' || line[i] == 'D' || line[i] == 'E' || line[i] == 'F')) {
				immediate += line[i];
			}
			else if (comma_first_place && isalpha(line[i])) {
				cout << "error, the " << line[i] << " not a hex value in " << line << endl;
				system("pause");
				exit(0);
			}
		}
		binary_code[address++] = code;
		int result = hex2dec(immediate);
		binary_code[address++] = bitset<16>(result).to_string();
	}
	else {
		code += opcodes["SHR"];
		string immediate = "";
		bool comma_first_place = 0;
		for (int i = 3;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000";
				code += registers[reg];
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (comma_first_place && (isdigit(line[i]) || line[i] == 'A' || line[i] == 'B' || line[i] == 'C' || line[i] == 'D' || line[i] == 'E' || line[i] == 'F')) {
				immediate += line[i];
			}
			else if (comma_first_place && isalpha(line[i])) {
				cout << "error, the " << line[i] << " not a hex value in " << line << endl;
				system("pause");
				exit(0);
			}
		}
		binary_code[address++] = code;
		int result = hex2dec(immediate);
		binary_code[address++] = bitset<16>(result).to_string();
	}
}
//-------------
void process_memory_operation(string line, int position) {
	string code = "";
	if (position == 1) {
		code += opcodes["PUSH"];
		for (int i = 4;i < line.size();++i) {
			if (line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000000";
				break;
			}
		}
		binary_code[address++] = code;
	}
	else if (position == 2) {
		code += opcodes["POP"];
		for (int i = 3;i < line.size();++i) {
			if (line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				break;
			}
		}
		binary_code[address++] = code;
	}
	else if (position == 3) {
		code += opcodes["LDM"];
		string immediate = "";
		bool comma_first_place = 0;
		for (int i = 3;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (comma_first_place && (isdigit(line[i]) || line[i] == 'A' || line[i] == 'B' || line[i] == 'C' || line[i] == 'D' || line[i] == 'E' || line[i] == 'F')) {
				immediate += line[i];
			}
			else if (comma_first_place && isalpha(line[i])) {
				cout << "error, the " << line[i] << " not a hex value in " << line << endl;
				system("pause");
				exit(0);
			}
		}
		binary_code[address++] = code;
		int result = hex2dec(immediate);
		binary_code[address++] = bitset<16>(result).to_string();
	}
	else if (position == 4) {
		code += opcodes["LDD"];
		string effective_address = "";
		bool comma_first_place = 0;
		for (int i = 3;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (comma_first_place && (isdigit(line[i]) || line[i] == 'A' || line[i] == 'B' || line[i] == 'C' || line[i] == 'D' || line[i] == 'E' || line[i] == 'F')) {
				effective_address += line[i];
			}
			else if (comma_first_place && isalpha(line[i])) {
				cout << "error, the " << line[i] << " not a hex value in " << line << endl;
				system("pause");
				exit(0);
			}
		}
		int result = hex2dec(effective_address);
		string temp = bitset<20>(result).to_string();
		int kk = 10;
		for (int i = 1;i < 4;++i) {
			code[kk++] = temp[i];
		}
		code[0] = temp[0];
		binary_code[address++] = code;
		code = "";
		for (int i = 4;i < temp.size();++i)code += temp[i];
		binary_code[address++] = code;
	}
	else {
		code += opcodes["STD"];
		string effective_address = "";
		bool comma_first_place = 0;
		for (int i = 3;i < line.size();++i) {
			if (line[i] == '#')break;
			if (!comma_first_place && line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000000";
			}
			else if (!comma_first_place && line[i] == ',') {
				comma_first_place = 1;
			}
			else if (comma_first_place && (isdigit(line[i]) || line[i] == 'A' || line[i] == 'B' || line[i] == 'C' || line[i] == 'D' || line[i] == 'E' || line[i] == 'F')) {
				effective_address += line[i];
			}
			else if (comma_first_place && isalpha(line[i])) {
				cout << "error, the " << line[i] << " not a hex value in " << line << endl;
				system("pause");
				exit(0);
			}
		}
		int result = hex2dec(effective_address);
		string temp = bitset<20>(result).to_string();
		int kk = 10;
		for (int i = 1;i < 4;++i) {
			code[kk++] = temp[i];
		}
		code[0] = temp[0];
		binary_code[address++] = code;
		code = "";
		for (int i = 4;i < temp.size();++i)code += temp[i];
		binary_code[address++] = code;
	}
}
//-------------
void process_branch_operation(string line, int position) {
	string code = "";
	if (position == 1) {
		code += opcodes["JZ"];
		for (int i = 2;i < line.size();++i) {
			if (line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000000";
				break;
			}
		}
		binary_code[address++] = code;
	}
	else if (position == 2) {
		code += opcodes["JMP"];
		for (int i = 3;i < line.size();++i) {
			if (line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000000";
				break;
			}
		}
		binary_code[address++] = code;
	}
	else if (position == 3) {
		code += opcodes["CALL"];
		for (int i = 2;i < line.size();++i) {
			if (line[i] == 'R') {
				string reg = "";reg += line[i];reg += line[i + 1];
				if (!(line[i + 1] - '0' >= 0 && line[i + 1] - '0' <= 7)) {
					cout << "error, this register is illegal" << line[i] << line[i + 1] << " in " << line;
					system("pause");
					exit(0);
				}
				code += registers[reg];
				code += "000000";
				break;
			}
		}
		binary_code[address++] = code;
	}
	else if (position == 4) {
		binary_code[address++] = opcodes["RET"];
	}
	else {
		binary_code[address++] = opcodes["RTI"];
	}
}
//-------------
void process_input_signal_operand(string line, int position) {
	if (position == 1) {
		binary_code[address++] = opcodes["RESET"];
	}
	else {
		binary_code[address++] = opcodes["INTERRUPT"];
	}
}
//--------------process line------------------------
void process_line(string line) {
	int k = 0;
	string operation = "";
	while (k < line.size() && line[k] != ' ') {
		operation += line[k++];
	}
	int position; //hwa meen fe el operations of 1st,2nd,... 
	if (is_one_operand(operation) > -1) {
		position = is_one_operand(operation);
		process_one_operand(line, position);
	}
	else if (is_two_operand(operation) > -1) {
		position = is_two_operand(operation);
		process_two_operand(line, position);
	}
	else if (is_memory_operation(operation) > -1) {
		position = is_memory_operation(operation);
		process_memory_operation(line, position);
	}
	else if (is_branch_and_change_operation(operation) > -1) {
		position = is_branch_and_change_operation(operation);
		process_branch_operation(line, position);
	}
	else if (is_input_signal_operand(operation) > -1) {
		position = is_input_signal_operand(operation);
		process_input_signal_operand(line, position);
	}
	else {
		//2ma b3d org deh 2w 7aga 8lt da5la
		string digit = "";
		for (int i = 0;i < line.size();++i) {
			if (isdigit(line[i]) || line[i] == 'A' || line[i] == 'B' || line[i] == 'C' || line[i] == 'D' || line[i] == 'E' || line[i] == 'F' || line[i] == 'a' || line[i] == 'b' || line[i] == 'c' || line[i] == 'd' || line[i] == 'e' || line[i] == 'f') {
				digit += line[i];
			}
			else if (isalpha(line[i])) {
				cout << "error at this line " << line << endl;
				cout << "the entered instruction is illegal or the number is not hexadecimal number";
				system("pause");
				exit(0);
			}
			else if (line[i] == '#' && digit.length() == 0)return;
		}
		if (digit.length() > 0) {
			if (address == 0) {
				binary_code[address++] = opcodes["LDM"] + registers["R0"];
				binary_code[address++] = bitset<16>(hex2dec(digit)).to_string();
				binary_code[address++] = opcodes["STD"] + registers["R0"] + "000000";
				binary_code[address++] = "0000000000000000";
			}
			else if (address == 2) {
				address += 2;
				binary_code[address++] = opcodes["LDM"] + registers["R0"];
				binary_code[address++] = bitset<16>(hex2dec(digit)).to_string();
				binary_code[address++] = opcodes["STD"] + registers["R0"] + "000000";
				binary_code[address++] = "0000000000000010";
			}
			else {
				binary_code[address++] = bitset<16>(hex2dec(digit)).to_string();
			}
		}
		else {
			string detect_spaces = "";
			for (int i = 0;i < line.size();++i) {
				if (line[i] != ' ')
					detect_spaces += line[i];
			}
			if (detect_spaces.size() != 0) {
				if (detect_spaces[0] != '#') {
					cout << "error at this line " << line << endl;
					cout << "the entered instruction is illegal or the number is not hexadecimal number";
					system("pause");
					exit(0);
				}
			}
		}
	}
}
//----------------read file-----------------------
void read_file_and_clean() {
	cout << "please enter the file name without (.txt)" << endl;
	//string file_name;
	string line;
	getline(cin, file_name);
	ifstream file(file_name + ".txt");
	int next_address;
	if (file.is_open()) {
		std::string line;
		while (getline(file, line)) {
			if (line == "" )
				continue;
			if (line[0] == '#')continue; //comment
			if (line[0] == '.' && (line[1] == 'O' || line[1] == 'o')) { //.org
				string org_num = "";
				for (int i = 5;i < line.size();++i) {
					if (line[i] == '#')break;
					if (line[i] != ' ')
						org_num += line[i];
				}
				address = hex2dec(org_num); //will work from
			}
			else {
				for (int i = 0;i < line.size();++i) {
					if (isalpha(line[i]))
						line[i] = toupper(line[i]);
				}
				process_line(line);
			}
		}
	}
}

//------------------ write assembled file --------------------

void write_assembled_file() {
	ofstream file(file_name + " assembled file.txt");
	file << "SIGNAL ram : ram_type := (" << endl;
	if (file.is_open()) {
		for (int i = 0;i < address;++i) {
			if (!(binary_code[i].size() == 0))
				file << i << "=> \"" << binary_code[i] << "\" ," << endl;
			else
				file << i << "=> \"" << opcodes["NOP"] << "\" ," << endl;
		}
	}
	if (address != 4095) {
		file << "OTHERS=>X\"0000\");" << endl;
	}
	else file << ");";
	file.close();
}
int main() {
	assign_opcodes_and_reg();
	read_file_and_clean();
	write_assembled_file();
	system("pause");
	return 0;
}
