﻿#include "GherkinParser.h"
#include "gherkin.h"

std::vector<std::u16string> GherkinParser::names = {
	AddComponent(u"GherkinParser", []() { return new GherkinParser; }),
};

GherkinParser::GherkinParser()
{
	provider.reset(new Gherkin::GherkinProvider());

	AddProperty(u"Keywords", u"КлючевыеСлова", nullptr,
		[&](VH value) { this->provider->setKeywords(value); }
	);

	AddProperty(u"PrimitiveEscaping", u"ПримитивноеЭкранирование", 
		[&](VH value) { this->result = this->provider->primitiveEscaping; },
		[&](VH value) { this->provider->primitiveEscaping = value; }
	);

	AddFunction(u"Parse", u"Прочитать",
		[&](VH data) {  this->result = this->provider->ParseText(data); }
	);

	AddFunction(u"ParseFile", u"ПрочитатьФайл",
		[&](VH filename) {  this->result = this->provider->ParseFile(filename); }
	);

	AddProcedure(u"Exit", u"ЗавершитьРаботуСистемы",
		[&](VH status) { this->ExitCurrentProcess(status); }, { {0, (int64_t)0 } }
	);
}

#ifdef _WINDOWS

void GherkinParser::ExitCurrentProcess(int64_t status)
{
	ExitProcess((UINT)status);
}

#else//_WINDOWS
void GherkinParser::ExitCurrentProcess(int64_t status)
{
	exit((int)status);
}

#endif//_WINDOWS
