#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОграниченияСвертки") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ОграниченияСвертки",
			НСтр("ru='Ограничения свертки'"),
			СформироватьТабличныйДокументОграниченияСвертки(
				МассивОбъектов,
				ОбъектыПечати,
				ПараметрыПечати));
	КонецЕсли;
КонецПроцедуры

Функция СформироватьТабличныйДокументОграниченияСвертки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	УстановитьПривилегированныйРежим(Истина);

	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ОриентацияСтраницы  = ОриентацияСтраницы.Ландшафт;
	ТабДок.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОграниченияСвертки";
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	
	ДатаСверткиИБ = ПараметрыПечати.ДатаСверткиИБ;
	
	СтруктураИсходныеДанные = ПолучитьИсходныеДанныеОбОграниченияхСвертки(ДатаСверткиИБ);
	ВозможныеОграничения = СтруктураИсходныеДанные.ТаблицаОграничений;
	ЕстьОграничения = СтруктураИсходныеДанные.ЕстьОграничения;
	МенеджерВТ = СтруктураИсходныеДанные.МенеджерВТ;
	
	Макет = ПолучитьМакет("МакетОграниченияСвертки");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ТабДок.Вывести(ОбластьЗаголовок);
	
	//Это для страховки. Если ограничений нет, гиперссылка с отчетом не видна на форме.
	Если НЕ ЕстьОграничения Тогда
		Область = Макет.ПолучитьОбласть("НетОграничений");
		ТабДок.Вывести(Область);
		УстановитьПривилегированныйРежим(Ложь);
		Возврат ТабДок;
	КонецЕсли;
	//Вывод списка ограничений с рекомендациями
	Область = Макет.ПолучитьОбласть("Шапка_ОбщийСписок");
	ТабДок.Вывести(Область);
	Для Каждого СтрокаОграничения ИЗ ВозможныеОграничения Цикл
		Если НЕ СтрокаОграничения.Обнаружено Тогда
			Продолжить;
		КонецЕсли;
		Область = Макет.ПолучитьОбласть("Строка_ОбщийСписок");
		Область.Параметры.Заполнить(СтрокаОграничения);
		ТабДок.Вывести(Область);
	КонецЦикла;
	//Вывод детальных данных по ограничениям
	Для Каждого СтрокаОграничения ИЗ ВозможныеОграничения Цикл
		Если НЕ СтрокаОграничения.Обнаружено Тогда
			Продолжить;
		КонецЕсли;
		Область = Макет.ПолучитьОбласть("Заголовок_Ограничение");
		Область.Параметры.Заполнить(СтрокаОграничения);
		ТабДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Шапка_"+СтрокаОграничения.Ограничение);
		ТабДок.Вывести(Область);
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
		Запрос.Текст = "ВЫБРАТЬ * ИЗ " + СтрокаОграничения.Ограничение;
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Область = Макет.ПолучитьОбласть("Строка_"+СтрокаОграничения.Ограничение);
			Область.Параметры.Заполнить(Выборка);
			ТабДок.Вывести(Область);
		КонецЦикла;
	КонецЦикла;

	УстановитьПривилегированныйРежим(Ложь);

	Возврат ТабДок;

КонецФункции

#КонецОбласти

#Область ДанныеОбОграниченияхСвертки
Функция ПолучитьИсходныеДанныеОбОграниченияхСвертки(ДатаСверткиИБ, ДляОтчета = Истина) Экспорт
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	//Запрос на получение исходных данных
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ %НеДляОтчета%
	|ДокументРеализации КАК Документ
	|ПОМЕСТИТЬ НеподтвержденныйНДС
	|ИЗ РегистрСведений.НДССостояниеРеализации0
	|ГДЕ ДатаПодтверждения > &ДатаОст И ДатаРеализации <= &ДатаОст
	|;
	|/////////////////////////////////////
	|ВЫБРАТЬ %НеДляОтчета%
	|ТабРегОстатки.ОрганизацияВладелец КАК Организация,
	|ТабРегОстатки.АналитикаУчетаНоменклатуры.МестоХранения КАК Склад
	|ПОМЕСТИТЬ ПередачаТоваров
	|ИЗ РегистрНакопления.ТоварыОрганизацийКПередаче.Остатки(&ГраницаОст,АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Склад)) КАК ТабРегОстатки
	|ЛЕВОЕ СОЕДИНЕНИЕ 
	|	РегистрНакопления.ТоварыОрганизацийКПередаче.Обороты(,&ГраницаОст,Регистратор) КАК ТабРегОбороты
	|	ПО ТабРегОстатки.ОрганизацияВладелец = ТабРегОбороты.ОрганизацияВладелец 
	|	И ТабРегОстатки.АналитикаУчетаНоменклатуры = ТабРегОбороты.АналитикаУчетаНоменклатуры 
	|	И ТабРегОстатки.ВидЗапасовПродавца = ТабРегОбороты.ВидЗапасовПродавца 
	|ГДЕ ТабРегОстатки.КоличествоОстаток > 0 И ТабРегОбороты.КоличествоПриход > 0
	|СГРУППИРОВАТЬ ПО
	|ТабРегОстатки.ОрганизацияВладелец, 
	|ТабРегОстатки.АналитикаУчетаНоменклатуры.МестоХранения 
	|;
	|/////////////////////////////////////
	|ВЫБРАТЬ %НеДляОтчета%
	|ТабРегОстатки.Организация КАК Организация,
	|ТабРегОстатки.Поставщик КАК Поставщик,
	|ТабРегОстатки.ДокументПоступления КАК Документ
	|ПОМЕСТИТЬ ТоварыКОформлению
	|ИЗ РегистрНакопления.ТоварыКОформлениюТаможенныхДеклараций.Остатки(&ГраницаОст) КАК ТабРегОстатки
	|ГДЕ ТабРегОстатки.КоличествоОстаток > 0 
	|СГРУППИРОВАТЬ ПО
	|ТабРегОстатки.Организация, 
	|ТабРегОстатки.Поставщик, 
	|ТабРегОстатки.ДокументПоступления
	|; 
	|/////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ %НеДляОтчета%
	|ВидЗапасов.ВладелецТовара КАК Комитент
	|ПОМЕСТИТЬ ОтчетКомитенту
	|ИЗ РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту.Остатки(&ГраницаОст)
	|ГДЕ КоличествоОстаток > 0
	|;
	|/////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ %НеДляОтчета%
	|АналитикаУчетаНоменклатуры.Номенклатура КАК Услуга,
	|Соглашение КАК Соглашение
	|ПОМЕСТИТЬ УслугиКОформлению
	|ИЗ РегистрНакопления.УслугиКОформлениюОтчетовПринципалу.Остатки(&ГраницаОст)
	|ГДЕ КоличествоОстаток > 0
	|; 
	|/////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ %НеДляОтчета%
	|Склад КАК Склад
	|ПОМЕСТИТЬ ИзлишкиНедостачи
	|ИЗ РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(&ГраницаОст)
	|ГДЕ КОформлениюАктовОстаток > 0 
	|;
	|/////////////////////////////////////
	|ВЫБРАТЬ %НеДляОтчета%
	|Организация КАК Организация,
	|ВидПереводаДенежныхСредств КАК ВидПереводаДенежныхСредств,
	|Получатель КАК Получатель,
	|Отправитель КАК Отправитель
	|ПОМЕСТИТЬ ДенежныеСредстваВПути
	|ИЗ РегистрНакопления.ДенежныеСредстваВПути.Остатки(&ГраницаОст)
	|ГДЕ СуммаОстаток > 0 И ВидПереводаДенежныхСредств <> ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПоступлениеОтБанкаПоЭквайрингу)
	|СГРУППИРОВАТЬ ПО Организация, ВидПереводаДенежныхСредств, Получатель, Отправитель
	|;
	|/////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ %НеДляОтчета%
	|Ссылка КАК Документ
	|ПОМЕСТИТЬ НеУдаленныеЧекиККМ
	|ИЗ Документ.ЧекККМ
	|ГДЕ Ссылка.Дата <= &ДатаОст
	|;
	|/////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ %НеДляОтчета%
	|Организация КАК Организация,
	|АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ ОтгрузкаБезПереходаПраваСобственности
	|ИЗ РегистрНакопления.СебестоимостьТоваров.Остатки(&ГраницаОст, РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыВПути))
	|ГДЕ КоличествоОстаток > 0 
	|;
	|";
	Если ДляОтчета Тогда
		//Нужны все данные
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%НеДляОтчета%", "");
	Иначе
		//Нужны данные только о том, какие ограничения есть
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%НеДляОтчета%", "ПЕРВЫЕ 1");
	КонецЕсли;
	Запрос.УстановитьПараметр("ДатаОст", КонецДня(ДатаСверткиИБ));
	Запрос.УстановитьПараметр("ПустаяДата", Дата("00010101"));
	Запрос.УстановитьПараметр("ГраницаОст", Новый Граница(КонецДня(ДатаСверткиИБ),ВидГраницы.Включая));

	Запрос.Выполнить();
	
	//Заполнение списка ограничений
	ВозможныеОграничения = Новый ТаблицаЗначений;
	ВозможныеОграничения.Колонки.Добавить("Ограничение");
	ВозможныеОграничения.Колонки.Добавить("Содержание");
	ВозможныеОграничения.Колонки.Добавить("Рекомендация");
	ВозможныеОграничения.Колонки.Добавить("Обнаружено");
	
	ДобавитьВозможноеОграничение(ВозможныеОграничения,"НеподтвержденныйНДС",
								НСтр("ru='Неподтвержденный НДС по ставке 0%'"),
								НСтр("ru='Данные будут потеряны. Не рекомендуется выполнять свертку'"));
								
	ДобавитьВозможноеОграничение(ВозможныеОграничения,"ТоварыКОформлению",
								НСтр("ru='Поступившие импортные товары, на которые не оформлена ГТД'"),
								НСтр("ru='Данные будут потеряны. Не рекомендуется выполнять свертку'"));


	ДобавитьВозможноеОграничение(ВозможныеОграничения,"ИзлишкиНедостачи",
								НСтр("ru='Не оформлены излишки и недостачи товаров'"),
								НСтр("ru='Перед сверткой оформить излишки и недостачи'"));

	ДобавитьВозможноеОграничение(ВозможныеОграничения,"ОтчетКомитенту",
								НСтр("ru='Не оформлены отчеты комитенту о продажах'"),
								НСтр("ru='Перед сверткой оформить отчеты комитенту'"));
	ДобавитьВозможноеОграничение(ВозможныеОграничения,"УслугиКОформлению",
								НСтр("ru='Не оформлены отчеты о продаже агентских услуг'"),
								НСтр("ru='Перед сверткой оформить отчеты о продаже агентских услуг'"));

	ДобавитьВозможноеОграничение(ВозможныеОграничения,"ПередачаТоваров",
								НСтр("ru='Не оформлена передача товаров между организациями'"),
								НСтр("ru='Перед сверткой оформить передачу товаров между организациями'"));
								
	ДобавитьВозможноеОграничение(ВозможныеОграничения,"ДенежныеСредстваВПути",
								НСтр("ru='Денежные средства в пути'"),
								НСтр("ru='Данные будут потеряны. Не рекомендуется выполнять свертку'"));

	ДобавитьВозможноеОграничение(ВозможныеОграничения,"НеУдаленныеЧекиККМ",
								НСтр("ru='Не выполнено архивирование и удаление чеков ККМ'"),
								НСтр("ru='Перед сверткой выполнить архивирование и удаление чеков ККМ'"));
	ДобавитьВозможноеОграничение(ВозможныеОграничения,"ОтгрузкаБезПереходаПраваСобственности",
								НСтр("ru='Отгрузка без перехода права собственности'"),
								НСтр("ru='Данные будут потеряны. Не рекомендуется выполнять свертку'"));

								
	ЕстьОграничения = Ложь;
	Для Каждого СтрокаОграничения ИЗ ВозможныеОграничения Цикл
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1 * ИЗ "+СтрокаОграничения.Ограничение;
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			СтрокаОграничения.Обнаружено = Истина;
			ЕстьОграничения = Истина;
			Если НЕ ДляОтчета Тогда
				Прервать;
			КонецЕсли;
		Иначе
			СтрокаОграничения.Обнаружено = Ложь;
		КонецЕсли;
	КонецЦикла;
	Если ДляОтчета Тогда
		Возврат Новый Структура("ЕстьОграничения, ТаблицаОграничений, МенеджерВТ", ЕстьОграничения, ВозможныеОграничения, МенеджерВТ);
	Иначе
		Возврат Новый Структура("ЕстьОграничения", ЕстьОграничения);
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьВозможноеОграничение(ВозможныеОграничения,Ограничение, Содержание, Рекомендация)
	СтрокаОграничения = ВозможныеОграничения.Добавить();
	СтрокаОграничения.Ограничение = Ограничение;
	СтрокаОграничения.Содержание = Содержание;
	СтрокаОграничения.Рекомендация = Рекомендация;
КонецПроцедуры

#КонецОбласти
#КонецОбласти

#КонецЕсли