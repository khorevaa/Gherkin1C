﻿&НаКлиенте
Перем ЕстьПроблема, ЕстьОшибка, ЕстьОшибкиПроблемы;

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МакетКомпоненты = ОбработкаОбъект.ПолучитьМакет("Gherkin1C");
	МестоположениеКомпоненты = ПоместитьВоВременноеХранилище(МакетКомпоненты, УникальныйИдентификатор);
	Параметры.Свойство("ИдентификаторКомпоненты", ИдентификаторКомпоненты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПустаяСтрока(ИдентификаторКомпоненты) Тогда
		ИдентификаторКомпоненты = "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
		ВыполнитьПодключениеВнешнейКомпоненты(Истина);
	Иначе
		ПодключениеВнешнейКомпонентыЗавершение(Истина, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключениеВнешнейКомпоненты(ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеВнешнейКомпонентыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты, ИдентификаторКомпоненты, ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеВнешнейКомпонентыЗавершение(Подключение, ДополнительныеПараметры) Экспорт
	
	Если Подключение Тогда
		НаборТестов = ПолучитьФормуПоИмени("Autotests", ЭтаФорма);
		НаборТестов.ЗаполнитьНаборТестов(ЭтаФорма);
	ИначеЕсли ДополнительныеПараметры = Истина Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключениеВнешнейКомпоненты", ЭтотОбъект, Ложь);
		НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура ТолькоВыделенные(Команда)
	
	ВыполнитьВыделенные();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВсе(Команда)
	
	ВыполнитьТесты();
	
КонецПроцедуры

#КонецОбласти

#Область ЭкспортныеМетоды

&НаКлиенте
Процедура Добавить(Знач ИмяМетода, Знач Представление) Экспорт
	
	ТекущаяСтрока = Результаты.ПолучитьЭлементы().Добавить();
	ТекущаяСтрока.Наименование = Представление;
	ТекущаяСтрока.ИмяМетода = ИмяМетода;
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьШаг(ТекущаяГруппа, Представление) Экспорт
	
	ТекущаяСтрока = ТекущаяГруппа.ПолучитьЭлементы().Добавить();
	ТекущаяСтрока.Наименование = Представление;
	ТекущаяСтрока.КартинкаСтрок = 1;
	Возврат ТекущаяСтрока;
	
КонецФункции	

&НаКлиенте
Функция ЗаписатьПроблему(ТекущаяГруппа, ТекущаяСтрока, ТекстПроблемы) Экспорт

	ЕстьПроблема = Истина;
	ЕстьОшибкиПроблемы = Истина; 
	
	Если ТекущаяСтрока = Неопределено Тогда
		ТекущаяСтрока = ТекущаяГруппа.ПолучитьЭлементы().Добавить();
		ТекущаяСтрока.Наименование = "Неизвестная проблема";
	КонецЕсли;
	
	ТекущаяСтрока.Подробности = ТекстПроблемы;
	
	Если ТекущаяСтрока.КартинкаСтрок <> 3 Тогда
		ТекущаяСтрока.КартинкаСтрок = 2;
	КонецЕсли;
	
	Если ТекущаяГруппа.КартинкаСтрок <> 3 Тогда
		ТекущаяГруппа.КартинкаСтрок = 2;
	КонецЕсли;
	
	Возврат ЭтаФорма;
	
КонецФункции

&НаКлиенте
Функция ПрерватьТест(ТекущаяГруппа, ТекущаяСтрока, Результат, Подробности) Экспорт
	
	ЕстьОшибка = Истина;
	ЕстьОшибкиПроблемы = Истина; 
	ТекущийТестПрерван = Истина;
	
	Если ТекущаяСтрока = Неопределено Тогда
		ТекущаяСтрока = ТекущаяГруппа.ПолучитьЭлементы().Добавить();
		ТекущаяСтрока.Наименование = "Неизвестная ошибка";
	КонецЕсли;
	
	ТекущаяСтрока.Эталон = Результат;
	ТекущаяСтрока.Подробности = Подробности;
	ТекущаяСтрока.КартинкаСтрок = 3;
	ТекущаяГруппа.КартинкаСтрок = 3;
	
	Возврат ЭтаФорма;
	
КонецФункции

#КонецОбласти

#Область СлужебныеФункции

&НаКлиенте
Функция ПолучитьФормуПоИмени(НовоеИмя, ФормаВладелец)
	
	ПозицияРазделителя = СтрНайти(ИмяФормы, ".", НаправлениеПоиска.СКонца);
	НовоеИмяФормы = Лев(ИмяФормы, ПозицияРазделителя) + НовоеИмя;
	Возврат ПолучитьФорму(НовоеИмяФормы, Неопределено, ФормаВладелец, Новый УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьТест(ГруппаТестов)
	
	ЕстьОшибка = Ложь;
	ЕстьПроблема = Ложь;
	
	xUnitBDD = ПолучитьФормуПоИмени("xUnitBDD", ЭтаФорма);
	xUnitBDD.Инициализация(ИдентификаторКомпоненты, ГруппаТестов);
	НаборТестов = ПолучитьФормуПоИмени("Autotests", xUnitBDD);
	
	Попытка
		ГруппаТестов.КартинкаСтрок = 0;
		ГруппаТестов.ПолучитьЭлементы().Очистить();
		Выполнить("НаборТестов." + ГруппаТестов.ИмяМетода + "(xUnitBDD)");
		ГруппаТестов.КартинкаСтрок = ?(ЕстьОшибка, 3, ?(ЕстьПроблема, 2, 1));
	Исключение
		Информация = ИнформацияОбОшибке();
		Результат = КраткоеПредставлениеОшибки(Информация);
		Подробности = ПодробноеПредставлениеОшибки(Информация);
		ПрерватьТест(ГруппаТестов, Неопределено, Результат, Подробности);
	КонецПопытки;
	
КонецПроцедуры	
 
&НаКлиенте
Процедура ВыполнитьТесты()
	
	ЕстьОшибкиПроблемы = Ложь;
	Для каждого ТекСтр Из Результаты.ПолучитьЭлементы() Цикл
		ВыполнитьТест(ТекСтр);
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Процедура ВыполнитьВыделенные()
	
	ЕстьОшибкиПроблемы = Ложь;
	ВыделенныеСтроки = Элементы.Результаты.ВыделенныеСтроки;
	Для каждого ТекСтр Из Результаты.ПолучитьЭлементы() Цикл
		Ид = ТекСтр.ПолучитьИдентификатор();
		Если ВыделенныеСтроки.Найти(Ид) <> Неопределено Тогда
			ВыполнитьТест(ТекСтр);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры	

#КонецОбласти
