#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИдентификаторПлатежа		= Неопределено;
	ВидыЗапасовУказаныВручную	= Ложь;
	
	ВидыЗапасов.Очистить();
	
	РасшифровкаПлатежаСКлиентом.Очистить();
	РасшифровкаПлатежаСПоставщиком.Очистить();
	РасшифровкаПлатежаСКлиентомВознаграждение.Очистить();
	РасшифровкаПлатежаСПоставщикомВознаграждение.Очистить();
	
	УчетНДСУП.СкорректироватьСтавкуНДС(СтавкаНДСВознаграждения, Дата);
	СуммаНДСВознаграждения = УчетНДСУПКлиентСервер.РассчитатьСуммуНДС(СуммаВознаграждения,
		УчетНДСУПКлиентСервер.ПолучитьСтавкуНДС(СтавкаНДСВознаграждения));
	
	УчетНДСУП.СкорректироватьСтавкуНДСВТЧДокумента(ЭтотОбъект, Товары);
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
 	Менеджер = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	   И ДанныеЗаполнения.Свойство("ЗаполнятьПоТоварамКОформлению") Тогда
	   
		Комиссионер = ДанныеЗаполнения.Комиссионер;
		Валюта = ДанныеЗаполнения.Валюта;
		Организация = ДанныеЗаполнения.Организация;
		НачалоПериода = ДанныеЗаполнения.НачалоПериода;
		КонецПериода = ДанныеЗаполнения.КонецПериода;
		Если ТекущаяДатаСеанса() > КонецМесяца(КонецПериода)
			И ЗначениеЗаполнено(КонецПериода) Тогда
			Дата = КонецПериода;
		Иначе
			Дата = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Договор") Тогда
			Договор = ДанныеЗаполнения.Договор;
			
			ИменаПолей = "НаправлениеДеятельности, ПорядокРасчетов";
			РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, ИменаПолей);
			НаправлениеДеятельности = РеквизитыДоговора.НаправлениеДеятельности;
			ПорядокРасчетов = РеквизитыДоговора.ПорядокРасчетов;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("НалогообложениеНДС") Тогда
			НалогообложениеНДС = ДанныеЗаполнения.НалогообложениеНДС;
		КонецЕсли;
		
		ЗаполнитьТоварыПоОстаткамКОформлению(ДанныеЗаполнения.КонецПериода);
		
	КонецЕсли;
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	ПроверитьОрганизации(Отказ);
	
	Документы.ОтчетПоКомиссииМеждуОрганизациями.ЗаполнитьИменаРеквизитовПоСпособуРасчетаВознаграждения(
		СпособРасчетаВознаграждения, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	Если Не РасчетыЧерезОтдельногоКонтрагента Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);

	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетПоКомиссииМеждуОрганизациями;
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);

	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	ВзаиморасчетыСервер.ПроверитьДатуПлатежа(ЭтотОбъект, Отказ);
	КомиссионнаяТорговляСервер.ПроверитьКорректностьПериода(ЭтотОбъект, Отказ);
	ПроверитьКорректностьПериодаИДаты(Отказ);
	Если СпособРасчетаВознаграждения <> Перечисления.СпособыРасчетаКомиссионногоВознаграждения.НеРассчитывается Тогда
		КомиссионнаяТорговляСервер.ПроверитьУслугуПоКомиссионномуВознаграждению(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	РасчетСуммаДокумента = Товары.Итог("СуммаПродажи");
	Если СуммаДокумента <> РасчетСуммаДокумента Тогда
		СуммаДокумента = РасчетСуммаДокумента;
	КонецЕсли;
	
	РасчетСуммаВознаграждения = Товары.Итог("СуммаВознаграждения");
	Если СуммаВознаграждения <> РасчетСуммаВознаграждения Тогда
		СуммаВознаграждения = РасчетСуммаВознаграждения;
	КонецЕсли;
	
	Если СуммаНДСВознаграждения <> Товары.Итог("СуммаНДСВознаграждения") Тогда
		КомиссионнаяТорговляСервер.ЗаполнитьСуммуНДСВознагражденияВТабличнойЧасти(Товары, СуммаНДСВознаграждения);
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьАналитикиУчетаНоменклатуры();
		ЗаполнитьВидыЗапасов(Отказ);
		
		Если СуммаДокумента > 0 Тогда
			Если НЕ РасчетыЧерезОтдельногоКонтрагента И НЕ ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
				РасчетыПоНакладнойКлиент    = Истина;
				РасчетыПоНакладнойПоставщик = Истина;
			ИначеЕсли РасчетыЧерезОтдельногоКонтрагента Тогда
				Если НЕ ЗначениеЗаполнено(ДоговорПродажи)
					ИЛИ НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорПродажи, "ПорядокРасчетов") = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
					РасчетыПоНакладнойКлиент    = Истина;
				Иначе
					РасчетыПоНакладнойКлиент    = Ложь;
				КонецЕсли;
				Если НЕ ЗначениеЗаполнено(ДоговорПокупки)
					ИЛИ НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорПокупки, "ПорядокРасчетов") = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
					РасчетыПоНакладнойПоставщик    = Истина;
				Иначе
					РасчетыПоНакладнойПоставщик    = Ложь;
				КонецЕсли;
			Иначе
				РасчетыПоНакладнойКлиент    = Ложь;
				РасчетыПоНакладнойПоставщик = Ложь;
			КонецЕсли;
		Иначе
			РасчетыПоНакладнойКлиент    = Ложь;
			РасчетыПоНакладнойПоставщик = Ложь;
		КонецЕсли;
		
		Если РасчетыПоНакладнойКлиент Тогда
			ВзаиморасчетыСервер.ЗаполнитьСуммыРасшифровкиНакладной(СуммаДокумента, СуммаДокумента, РасшифровкаПлатежаСКлиентом);
			Если УдержатьВознаграждение Тогда
				РасшифровкаПлатежаСКлиентомВознаграждение.Очистить();
			КонецЕсли;
			ВзаиморасчетыСервер.ЗаполнитьСуммыРасшифровкиНакладной(СуммаВознаграждения, СуммаВознаграждения, РасшифровкаПлатежаСКлиентомВознаграждение);
		Иначе
			Если РасшифровкаПлатежаСКлиентом.Количество() <> 0 Тогда
				РасшифровкаПлатежаСКлиентом.Очистить();
				РасшифровкаПлатежаСКлиентомВознаграждение.Очистить();
			КонецЕсли;
		КонецЕсли;
		
		Если РасчетыПоНакладнойПоставщик Тогда
			ВзаиморасчетыСервер.ЗаполнитьСуммыРасшифровкиНакладной(СуммаДокумента, СуммаДокумента, РасшифровкаПлатежаСПоставщиком);
			Если УдержатьВознаграждение Тогда
				РасшифровкаПлатежаСПоставщикомВознаграждение.Очистить();
			КонецЕсли;
			ВзаиморасчетыСервер.ЗаполнитьСуммыРасшифровкиНакладной(СуммаВознаграждения, СуммаВознаграждения, РасшифровкаПлатежаСПоставщикомВознаграждение);
		Иначе
			Если РасшифровкаПлатежаСПоставщиком.Количество() <> 0 Тогда
				РасшифровкаПлатежаСПоставщиком.Очистить();
				РасшифровкаПлатежаСПоставщикомВознаграждение.Очистить();
			КонецЕсли;
		КонецЕсли;
		
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Товары);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ВидыЗапасов);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	Если РасчетыЧерезОтдельногоКонтрагента И Организация <> Справочники.Организации.УправленческаяОрганизация Тогда
		Если Не ЗначениеЗаполнено(ДатаВходящегоДокумента) Тогда
			ДатаВходящегоДокумента = НачалоДня(Дата);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(НомерВходящегоДокумента) Тогда
			НомерВходящегоДокумента = Номер;
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(ДатаВходящегоДокумента) Тогда
			ДатаВходящегоДокумента = Неопределено;
		КонецЕсли;
		Если ЗначениеЗаполнено(НомерВходящегоДокумента) Тогда
			НомерВходящегоДокумента = "";
		КонецЕсли;
	КонецЕсли;
		
	Если Не РасчетыЧерезОтдельногоКонтрагента Тогда
		Если ЗначениеЗаполнено(Партнер) Тогда
			Партнер = Неопределено;
		КонецЕсли;
		Если ЗначениеЗаполнено(Контрагент) Тогда
			Контрагент = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	// Очистим реквизиты документа не используемые для способа расчета вознаграждения.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.ОтчетПоКомиссииМеждуОрганизациями.ЗаполнитьИменаРеквизитовПоСпособуРасчетаВознаграждения(
		СпособРасчетаВознаграждения,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоЗаказамНакладным;
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;
	
	ИдентификаторПлатежа = ОбщегоНазначенияУТ.ПолучитьУникальныйИдентификаторПлатежа(ЭтотОбъект);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурКомиссионеру(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыКомиссионеруПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ОтчетПоКомиссииМеждуОрганизациями.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитента(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьУслугиКОформлениюОтчетовПринципалу(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыПереданныеНаКомиссию(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьВыручкуИСебестоимостьПродаж(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	УчетНДСУП.СформироватьДвиженияВРегистры(ДополнительныеСвойства, Движения, Отказ);
	
	УправленческийУчетПроведениеСервер.ОтразитьЗакупки(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурКомиссионеру(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыКомиссионеруПриПроведении(ПараметрыРегистрации);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриПроведении(ПараметрыРегистрации);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриПроведении(ПараметрыРегистрации);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурКомиссионеру(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыКомиссионеруПриУдаленииПроведения(ПараметрыРегистрации);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриУдаленииПроведения(ПараметрыРегистрации);
	
	ПараметрыРегистрации = Документы.ВыкупВозвратнойТарыУПоставщика.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриУдаленииПроведения(ПараметрыРегистрации);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьТоварыПоОстаткамКОформлению(ДатаЗаполнения) Экспорт
	
	ПараметрыЗаполнения = Новый Структура();
	ПараметрыЗаполнения.Вставить("Организация", Комиссионер);
	ПараметрыЗаполнения.Вставить("Партнер", Организация);
	ПараметрыЗаполнения.Вставить("Соглашение", Справочники.СоглашенияСПоставщиками.ПустаяСсылка());
	ПараметрыЗаполнения.Вставить("Контрагент", Неопределено);
	ПараметрыЗаполнения.Вставить("Договор", Договор);
	ПараметрыЗаполнения.Вставить("Валюта", Валюта);
	ПараметрыЗаполнения.Вставить("НалогообложениеНДС", НалогообложениеНДС);
	ПараметрыЗаполнения.Вставить("ЦенаВключаетНДС", ЦенаВключаетНДС);
	ПараметрыЗаполнения.Вставить("Товары", Товары);
	ПараметрыЗаполнения.Вставить("Дата", Дата);
	
	КомиссионнаяТорговляСервер.ЗаполнитьПоТоварамКОформлениюОтчетовКомитентуЗаПериод(
		ПараметрыЗаполнения,
		НачалоПериода,
		?(ЗначениеЗаполнено(КонецПериода), КонецПериода, КонецМесяца(Дата)),
		Истина);
		
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		ВидЦены = Справочники.ВидыЦен.ВидЦеныПоУмолчанию(ВидЦены, Новый Структура("ИспользоватьПриПередачеМеждуОрганизациями", Истина));
	КонецЕсли;
	Если ЗначениеЗаполнено(ВидЦены) Тогда
		Реквизиты = Справочники.ВидыЦен.ПолучитьРеквизитыВидаЦены(ВидЦены);
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			Валюта = Реквизиты.ВалютаЦены;
		КонецЕсли;
		ВалютаВзаиморасчетов = Реквизиты.ВалютаЦены;
		ЦенаВключаетНДС = Реквизиты.ЦенаВключаетНДС;
		
		ПараметрыЗаполнения = Новый Структура();
		ПараметрыЗаполнения.Вставить("Дата", Дата);
		ПараметрыЗаполнения.Вставить("Валюта", Валюта);
		ПараметрыЗаполнения.Вставить("ВидЦены", ВидЦены);
		ПараметрыЗаполнения.Вставить("ПоляЗаполнения", "Цена, ВидЦены");
		
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
		
		СтруктураДействий = Новый Структура();
		СтруктураДействий.Вставить("ПересчитатьСумму", "КоличествоУпаковок");
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);

		ПродажиСервер.ЗаполнитьЦены(Товары, , ПараметрыЗаполнения, СтруктураДействий);
	КонецЕсли;
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Организация		= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта			= ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
	ВидЦены			= Справочники.ВидыЦен.ВидЦеныПоУмолчанию(ВидЦены, 
						Новый Структура("ИспользоватьПриПередачеМеждуОрганизациями", Истина));
	
	ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(Валюта, НалогообложениеНДС, Валюта);
	ХозяйственнаяОперация = Перечисления.ТипыДоговоровМеждуОрганизациями.Комиссионный;
	ГруппаФинансовогоУчета	= Справочники.ГруппыФинансовогоУчетаРасчетов.ПолучитьГруппуФинансовогоУчетаПоУмолчанию(ПорядокОплаты, ХозяйственнаяОперация);
	ГруппаФинансовогоУчетаПолучателя = Справочники.ГруппыФинансовогоУчетаРасчетов.ПолучитьГруппуФинансовогоУчетаПоУмолчанию(ПорядокОплаты, ХозяйственнаяОперация, Истина);
	
	Если Не ЗначениеЗаполнено(НалогообложениеНДС) Тогда
		ПараметрыЗаполнения = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыЗаполненияНалогообложенияНДС(ЭтотОбъект);
		УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьАналитикиУчетаНоменклатуры()
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
		Перечисления.ХозяйственныеОперации.ОтчетКомитенту,
		Неопределено,
		Подразделение,
		Организация);
	
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.СтатусУказанияСерий = "";
	ИменаПолей.Назначение = "";
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(
		Товары,
		МестаУчета,
		ИменаПолей);
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
		ИЛИ ПерезаполнитьВидыЗапасов
		ИЛИ ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		ИЛИ ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
	
		ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
		ПараметрыЗаполнения.ИмяТаблицыОстатков = "КомиссионныеТоварыИнтеркампани";
		ПараметрыЗаполнения.ПриПодбореПоИнтеркампаниИсключатьОрганизации = Комиссионер;
	
		ОтборыВидовЗапасов = ПараметрыЗаполнения.ОтборыВидовЗапасов;
		ОтборыВидовЗапасов.Организация = Комиссионер;
		ОтборыВидовЗапасов.ВладелецТовара = Организация;
		ОтборыВидовЗапасов.Валюта = Валюта;
		ОтборыВидовЗапасов.ТипЗапасов = Перечисления.ТипыЗапасов.КомиссионныйТовар;
		Если ЗначениеЗаполнено(Договор) Тогда
			ОтборыВидовЗапасов.Договор = Договор;
		Иначе
			ОтборыВидовЗапасов.Договор = Новый Массив;
			ОтборыВидовЗапасов.Договор.Добавить(Неопределено);
			ОтборыВидовЗапасов.Договор.Добавить(Справочники.ДоговорыМеждуОрганизациями.ПустаяСсылка());
		КонецЕсли;
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоКомиссионнымТоварамИнтеркампани(ЭтотОбъект, МенеджерВременныхТаблиц, Отказ, ПараметрыЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Функция ВременныеТаблицыДанныхДокумента()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Комиссионер КАК Комиссионер,
	|	&Организация КАК Партнер,
	|	&Организация КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	&Договор КАК Договор,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	&Валюта КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтчетПоКомиссииМеждуОрганизациями) КАК ХозяйственнаяОперация,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка КАК Упаковка,
	|	ТаблицаТоваров.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаТоваров.СчетФактураВыставленныйКомиссионера КАК СчетФактураВыставленныйКомиссионера,
	|	ТаблицаТоваров.Покупатель КАК Покупатель,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаПродажи КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаПродажиНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаВознаграждения КАК СуммаВознаграждения,
	|	ТаблицаТоваров.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов
	|	
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
	|	0 КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка КАК Упаковка,
	|	ТаблицаТоваров.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаТоваров.СчетФактураВыставленныйКомиссионера КАК СчетФактураВыставленныйКомиссионера,
	|	ТаблицаТоваров.Покупатель КАК Покупатель,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаВознаграждения КАК СуммаВознаграждения,
	|	ТаблицаТоваров.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения,
	|	ТаблицаТоваров.Склад КАК Склад,
	|	ТаблицаТоваров.Сделка КАК Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ТаблицаТоваров.ПодбиратьВидыЗапасов КАК ПодбиратьВидыЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка) КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|	ПО ТаблицаТоваров.Номенклатура = СправочникНоменклатура.Ссылка
	|ГДЕ
	|	СправочникНоменклатура.ТипНоменклатуры В (
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаВидыЗапасов.СчетФактураВыставленныйКомиссионера КАК СчетФактураВыставленныйКомиссионера,
	|	ТаблицаВидыЗапасов.Покупатель КАК Покупатель,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаВознаграждения КАК СуммаВознаграждения,
	|	ТаблицаВидыЗапасов.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаВидыЗапасов.СчетФактураВыставленныйКомиссионера КАК СчетФактураВыставленныйКомиссионера,
	|	ТаблицаВидыЗапасов.Покупатель КАК Покупатель,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаВознаграждения КАК СуммаВознаграждения,
	|	ТаблицаВидыЗапасов.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|	ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Комиссионер", Комиссионер);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Процедура ПроверитьОрганизации(Отказ)
	
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(Комиссионер) Тогда
		
		Если Организация = Комиссионер Тогда
			
			Текст = НСтр("ru = 'Одна и та же организация не может являться комитентом и комиссионером одновременно'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"Организация",
				,
				Отказ);
			
		ИначеЕсли ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс")
			И Справочники.Организации.ОрганизацииВзаимосвязаныПоОрганизационнойСтруктуре(Организация, Комиссионер) Тогда
		
			Текст = НСтр("ru = 'Организация-получатель не должна быть взаимосвязана с организацией-отправителем по организационной структуре.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"Комиссионер",
				,
				Отказ);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация, Дата, Комиссионер, Валюта";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаТоваров.Покупатель КАК Покупатель
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|		ТаблицаТоваров.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактурыКомиссионера,
	|		ТаблицаТоваров.СчетФактураВыставленныйКомиссионера КАК СчетФактураВыставленныйКомиссионера,
	|		ТаблицаТоваров.Покупатель КАК Покупатель,
	|		ТаблицаТоваров.Количество КАК Количество,
	|		ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|		ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|		ТаблицаТоваров.СуммаВознаграждения КАК СуммаВознаграждения,
	|		ТаблицаТоваров.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|	ГДЕ
	|		ТаблицаТоваров.Номенклатура.ТипНоменклатуры В
	|			(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|		ТаблицаВидыЗапасов.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактурыКомиссионера,
	|		ТаблицаВидыЗапасов.СчетФактураВыставленныйКомиссионера КАК СчетФактураВыставленныйКомиссионера,
	|		ТаблицаВидыЗапасов.Покупатель КАК Покупатель,
	|		-ТаблицаВидыЗапасов.Количество КАК Количество,
	|		-ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|		-ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|		-ТаблицаВидыЗапасов.СуммаВознаграждения КАК СуммаВознаграждения,
	|		-ТаблицаВидыЗапасов.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.СтавкаНДС,
	|	ТаблицаТоваров.ДатаСчетаФактурыКомиссионера,
	|	ТаблицаТоваров.СчетФактураВыставленныйКомиссионера,
	|	ТаблицаТоваров.Покупатель
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаСНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаВознаграждения) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаНДСВознаграждения) <> 0
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Процедура ПроверитьКорректностьПериодаИДаты(Отказ) Экспорт
	
	Если КонецМесяца(Дата) <> КонецМесяца(КонецПериода)
		ИЛИ НачалоМесяца(Дата) <> НачалоМесяца(НачалоПериода) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Период, за который отчитывается комиссионер, должен находиться в том же месяце, в котором проводится документ.'"),
			,
			"УстановитьИнтервал",
			"Объект",
			Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
