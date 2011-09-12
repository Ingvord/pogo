/*
* generated by Xtext
*/
package fr.esrf.tango.pogo.contentassist.antlr;

import java.util.Collection;
import java.util.Map;
import java.util.HashMap;

import org.antlr.runtime.CharStream;
import org.antlr.runtime.RecognitionException;
import org.eclipse.xtext.AbstractElement;
import org.eclipse.xtext.ui.common.editor.contentassist.antlr.AbstractContentAssistParser;
import org.eclipse.xtext.ui.common.editor.contentassist.antlr.FollowElement;
import org.eclipse.xtext.ui.common.editor.contentassist.antlr.internal.AbstractInternalContentAssistParser;

import com.google.inject.Inject;

import fr.esrf.tango.pogo.services.PogoDslGrammarAccess;

public class PogoDslParser extends AbstractContentAssistParser {
	
	@Inject
	private PogoDslGrammarAccess grammarAccess;
	
	private Map<AbstractElement, String> nameMappings;
	
	@Override
	protected fr.esrf.tango.pogo.contentassist.antlr.internal.InternalPogoDslLexer createLexer(CharStream stream) {
		return new fr.esrf.tango.pogo.contentassist.antlr.internal.InternalPogoDslLexer(stream);
	}
	
	@Override
	protected fr.esrf.tango.pogo.contentassist.antlr.internal.InternalPogoDslParser createParser() {
		fr.esrf.tango.pogo.contentassist.antlr.internal.InternalPogoDslParser result = new fr.esrf.tango.pogo.contentassist.antlr.internal.InternalPogoDslParser(null);
		result.setGrammarAccess(grammarAccess);
		return result;
	}
	
	@Override
	protected String getRuleName(AbstractElement element) {
		if (nameMappings == null) {
			nameMappings = new HashMap<AbstractElement, String>() {
				{
					put(grammarAccess.getLanguageAccess().getAlternatives(), "rule__Language__Alternatives");
					put(grammarAccess.getDisplayLevelAccess().getAlternatives(), "rule__DisplayLevel__Alternatives");
					put(grammarAccess.getAttrTypeAccess().getAlternatives(), "rule__AttrType__Alternatives");
					put(grammarAccess.getRW_TypeAccess().getAlternatives(), "rule__RW_Type__Alternatives");
					put(grammarAccess.getBooleanAccess().getAlternatives(), "rule__Boolean__Alternatives");
					put(grammarAccess.getPropTypeAccess().getAlternatives(), "rule__PropType__Alternatives");
					put(grammarAccess.getSimpleTypeAccess().getAlternatives(), "rule__SimpleType__Alternatives");
					put(grammarAccess.getVectorTypeAccess().getAlternatives(), "rule__VectorType__Alternatives");
					put(grammarAccess.getTypeAccess().getAlternatives(), "rule__Type__Alternatives");
					put(grammarAccess.getPogoSystemAccess().getGroup(), "rule__PogoSystem__Group__0");
					put(grammarAccess.getImportAccess().getGroup(), "rule__Import__Group__0");
					put(grammarAccess.getPogoMultiClassesAccess().getGroup(), "rule__PogoMultiClasses__Group__0");
					put(grammarAccess.getOneClassSimpleDefAccess().getGroup(), "rule__OneClassSimpleDef__Group__0");
					put(grammarAccess.getPogoDeviceClassAccess().getGroup(), "rule__PogoDeviceClass__Group__0");
					put(grammarAccess.getPogoDeviceClassAccess().getGroup_3(), "rule__PogoDeviceClass__Group_3__0");
					put(grammarAccess.getClassDescriptionAccess().getGroup(), "rule__ClassDescription__Group__0");
					put(grammarAccess.getInheritanceAccess().getGroup(), "rule__Inheritance__Group__0");
					put(grammarAccess.getClassIdentificationAccess().getGroup(), "rule__ClassIdentification__Group__0");
					put(grammarAccess.getPreferencesAccess().getGroup(), "rule__Preferences__Group__0");
					put(grammarAccess.getStateAccess().getGroup(), "rule__State__Group__0");
					put(grammarAccess.getPropertyAccess().getGroup(), "rule__Property__Group__0");
					put(grammarAccess.getInheritanceStatusAccess().getGroup(), "rule__InheritanceStatus__Group__0");
					put(grammarAccess.getCommandAccess().getGroup(), "rule__Command__Group__0");
					put(grammarAccess.getArgumentAccess().getGroup(), "rule__Argument__Group__0");
					put(grammarAccess.getAttributeAccess().getGroup(), "rule__Attribute__Group__0");
					put(grammarAccess.getFireEventsAccess().getGroup(), "rule__FireEvents__Group__0");
					put(grammarAccess.getAttrPropertiesAccess().getGroup(), "rule__AttrProperties__Group__0");
					put(grammarAccess.getAdditionalFileAccess().getGroup(), "rule__AdditionalFile__Group__0");
					put(grammarAccess.getVoidTypeAccess().getGroup(), "rule__VoidType__Group__0");
					put(grammarAccess.getBooleanTypeAccess().getGroup(), "rule__BooleanType__Group__0");
					put(grammarAccess.getShortTypeAccess().getGroup(), "rule__ShortType__Group__0");
					put(grammarAccess.getUShortTypeAccess().getGroup(), "rule__UShortType__Group__0");
					put(grammarAccess.getIntTypeAccess().getGroup(), "rule__IntType__Group__0");
					put(grammarAccess.getUIntTypeAccess().getGroup(), "rule__UIntType__Group__0");
					put(grammarAccess.getFloatTypeAccess().getGroup(), "rule__FloatType__Group__0");
					put(grammarAccess.getDoubleTypeAccess().getGroup(), "rule__DoubleType__Group__0");
					put(grammarAccess.getStringTypeAccess().getGroup(), "rule__StringType__Group__0");
					put(grammarAccess.getCharArrayTypeAccess().getGroup(), "rule__CharArrayType__Group__0");
					put(grammarAccess.getShortArrayTypeAccess().getGroup(), "rule__ShortArrayType__Group__0");
					put(grammarAccess.getUShortArrayTypeAccess().getGroup(), "rule__UShortArrayType__Group__0");
					put(grammarAccess.getIntArrayTypeAccess().getGroup(), "rule__IntArrayType__Group__0");
					put(grammarAccess.getUIntArrayTypeAccess().getGroup(), "rule__UIntArrayType__Group__0");
					put(grammarAccess.getFloatArrayTypeAccess().getGroup(), "rule__FloatArrayType__Group__0");
					put(grammarAccess.getDoubleArrayTypeAccess().getGroup(), "rule__DoubleArrayType__Group__0");
					put(grammarAccess.getStringArrayTypeAccess().getGroup(), "rule__StringArrayType__Group__0");
					put(grammarAccess.getLongStringArrayTypeAccess().getGroup(), "rule__LongStringArrayType__Group__0");
					put(grammarAccess.getDoubleStringArrayTypeAccess().getGroup(), "rule__DoubleStringArrayType__Group__0");
					put(grammarAccess.getStateTypeAccess().getGroup(), "rule__StateType__Group__0");
					put(grammarAccess.getConstStringTypeAccess().getGroup(), "rule__ConstStringType__Group__0");
					put(grammarAccess.getBooleanArrayTypeAccess().getGroup(), "rule__BooleanArrayType__Group__0");
					put(grammarAccess.getUCharTypeAccess().getGroup(), "rule__UCharType__Group__0");
					put(grammarAccess.getLongTypeAccess().getGroup(), "rule__LongType__Group__0");
					put(grammarAccess.getULongTypeAccess().getGroup(), "rule__ULongType__Group__0");
					put(grammarAccess.getLongArrayTypeAccess().getGroup(), "rule__LongArrayType__Group__0");
					put(grammarAccess.getULongArrayTypeAccess().getGroup(), "rule__ULongArrayType__Group__0");
					put(grammarAccess.getDevIntTypeAccess().getGroup(), "rule__DevIntType__Group__0");
					put(grammarAccess.getEncodedTypeAccess().getGroup(), "rule__EncodedType__Group__0");
					put(grammarAccess.getShortVectorTypeAccess().getGroup(), "rule__ShortVectorType__Group__0");
					put(grammarAccess.getIntVectorTypeAccess().getGroup(), "rule__IntVectorType__Group__0");
					put(grammarAccess.getFloatVectorTypeAccess().getGroup(), "rule__FloatVectorType__Group__0");
					put(grammarAccess.getDoubleVectorTypeAccess().getGroup(), "rule__DoubleVectorType__Group__0");
					put(grammarAccess.getStringVectorTypeAccess().getGroup(), "rule__StringVectorType__Group__0");
					put(grammarAccess.getPogoSystemAccess().getImportsAssignment_0(), "rule__PogoSystem__ImportsAssignment_0");
					put(grammarAccess.getPogoSystemAccess().getClassesAssignment_1(), "rule__PogoSystem__ClassesAssignment_1");
					put(grammarAccess.getPogoSystemAccess().getMultiClassesAssignment_2(), "rule__PogoSystem__MultiClassesAssignment_2");
					put(grammarAccess.getImportAccess().getImportURIAssignment_1(), "rule__Import__ImportURIAssignment_1");
					put(grammarAccess.getPogoMultiClassesAccess().getNameAssignment_1(), "rule__PogoMultiClasses__NameAssignment_1");
					put(grammarAccess.getPogoMultiClassesAccess().getSourcePathAssignment_3(), "rule__PogoMultiClasses__SourcePathAssignment_3");
					put(grammarAccess.getPogoMultiClassesAccess().getDescriptionAssignment_4(), "rule__PogoMultiClasses__DescriptionAssignment_4");
					put(grammarAccess.getPogoMultiClassesAccess().getTitleAssignment_5(), "rule__PogoMultiClasses__TitleAssignment_5");
					put(grammarAccess.getPogoMultiClassesAccess().getClassesAssignment_7(), "rule__PogoMultiClasses__ClassesAssignment_7");
					put(grammarAccess.getPogoMultiClassesAccess().getFilestogenerateAssignment_8(), "rule__PogoMultiClasses__FilestogenerateAssignment_8");
					put(grammarAccess.getPogoMultiClassesAccess().getPreferencesAssignment_9(), "rule__PogoMultiClasses__PreferencesAssignment_9");
					put(grammarAccess.getOneClassSimpleDefAccess().getClassnameAssignment_0(), "rule__OneClassSimpleDef__ClassnameAssignment_0");
					put(grammarAccess.getOneClassSimpleDefAccess().getSourcePathAssignment_1(), "rule__OneClassSimpleDef__SourcePathAssignment_1");
					put(grammarAccess.getOneClassSimpleDefAccess().getPogo6Assignment_2(), "rule__OneClassSimpleDef__Pogo6Assignment_2");
					put(grammarAccess.getOneClassSimpleDefAccess().getInheritancesAssignment_4(), "rule__OneClassSimpleDef__InheritancesAssignment_4");
					put(grammarAccess.getOneClassSimpleDefAccess().getParentClassesAssignment_6(), "rule__OneClassSimpleDef__ParentClassesAssignment_6");
					put(grammarAccess.getOneClassSimpleDefAccess().getAdditionalFilesAssignment_8(), "rule__OneClassSimpleDef__AdditionalFilesAssignment_8");
					put(grammarAccess.getPogoDeviceClassAccess().getNameAssignment_1(), "rule__PogoDeviceClass__NameAssignment_1");
					put(grammarAccess.getPogoDeviceClassAccess().getIsAbstractAssignment_2(), "rule__PogoDeviceClass__IsAbstractAssignment_2");
					put(grammarAccess.getPogoDeviceClassAccess().getBaseClassAssignment_3_1(), "rule__PogoDeviceClass__BaseClassAssignment_3_1");
					put(grammarAccess.getPogoDeviceClassAccess().getInstituteAssignment_5(), "rule__PogoDeviceClass__InstituteAssignment_5");
					put(grammarAccess.getPogoDeviceClassAccess().getDescriptionAssignment_7(), "rule__PogoDeviceClass__DescriptionAssignment_7");
					put(grammarAccess.getPogoDeviceClassAccess().getClassPropertiesAssignment_9(), "rule__PogoDeviceClass__ClassPropertiesAssignment_9");
					put(grammarAccess.getPogoDeviceClassAccess().getDevicePropertiesAssignment_11(), "rule__PogoDeviceClass__DevicePropertiesAssignment_11");
					put(grammarAccess.getPogoDeviceClassAccess().getCommandsAssignment_13(), "rule__PogoDeviceClass__CommandsAssignment_13");
					put(grammarAccess.getPogoDeviceClassAccess().getAttributesAssignment_15(), "rule__PogoDeviceClass__AttributesAssignment_15");
					put(grammarAccess.getPogoDeviceClassAccess().getDynamicAttributesAssignment_17(), "rule__PogoDeviceClass__DynamicAttributesAssignment_17");
					put(grammarAccess.getPogoDeviceClassAccess().getStatesAssignment_19(), "rule__PogoDeviceClass__StatesAssignment_19");
					put(grammarAccess.getPogoDeviceClassAccess().getPreferencesAssignment_20(), "rule__PogoDeviceClass__PreferencesAssignment_20");
					put(grammarAccess.getPogoDeviceClassAccess().getAdditionalFilesAssignment_22(), "rule__PogoDeviceClass__AdditionalFilesAssignment_22");
					put(grammarAccess.getClassDescriptionAccess().getDescriptionAssignment_0(), "rule__ClassDescription__DescriptionAssignment_0");
					put(grammarAccess.getClassDescriptionAccess().getTitleAssignment_1(), "rule__ClassDescription__TitleAssignment_1");
					put(grammarAccess.getClassDescriptionAccess().getSourcePathAssignment_2(), "rule__ClassDescription__SourcePathAssignment_2");
					put(grammarAccess.getClassDescriptionAccess().getInheritancesAssignment_4(), "rule__ClassDescription__InheritancesAssignment_4");
					put(grammarAccess.getClassDescriptionAccess().getLanguageAssignment_5(), "rule__ClassDescription__LanguageAssignment_5");
					put(grammarAccess.getClassDescriptionAccess().getFilestogenerateAssignment_6(), "rule__ClassDescription__FilestogenerateAssignment_6");
					put(grammarAccess.getClassDescriptionAccess().getIdentificationAssignment_7(), "rule__ClassDescription__IdentificationAssignment_7");
					put(grammarAccess.getClassDescriptionAccess().getCommentsAssignment_8(), "rule__ClassDescription__CommentsAssignment_8");
					put(grammarAccess.getClassDescriptionAccess().getHasMandatoryPropertyAssignment_9(), "rule__ClassDescription__HasMandatoryPropertyAssignment_9");
					put(grammarAccess.getClassDescriptionAccess().getHasAbstractCommandAssignment_10(), "rule__ClassDescription__HasAbstractCommandAssignment_10");
					put(grammarAccess.getClassDescriptionAccess().getHasAbstractAttributeAssignment_11(), "rule__ClassDescription__HasAbstractAttributeAssignment_11");
					put(grammarAccess.getClassDescriptionAccess().getDescriptionHtmlExistsAssignment_12(), "rule__ClassDescription__DescriptionHtmlExistsAssignment_12");
					put(grammarAccess.getInheritanceAccess().getClassnameAssignment_0(), "rule__Inheritance__ClassnameAssignment_0");
					put(grammarAccess.getInheritanceAccess().getSourcePathAssignment_1(), "rule__Inheritance__SourcePathAssignment_1");
					put(grammarAccess.getClassIdentificationAccess().getContactAssignment_0(), "rule__ClassIdentification__ContactAssignment_0");
					put(grammarAccess.getClassIdentificationAccess().getAuthorAssignment_1(), "rule__ClassIdentification__AuthorAssignment_1");
					put(grammarAccess.getClassIdentificationAccess().getEmailDomainAssignment_2(), "rule__ClassIdentification__EmailDomainAssignment_2");
					put(grammarAccess.getClassIdentificationAccess().getClassFamilyAssignment_3(), "rule__ClassIdentification__ClassFamilyAssignment_3");
					put(grammarAccess.getClassIdentificationAccess().getSiteSpecificAssignment_4(), "rule__ClassIdentification__SiteSpecificAssignment_4");
					put(grammarAccess.getClassIdentificationAccess().getPlatformAssignment_5(), "rule__ClassIdentification__PlatformAssignment_5");
					put(grammarAccess.getClassIdentificationAccess().getBusAssignment_6(), "rule__ClassIdentification__BusAssignment_6");
					put(grammarAccess.getClassIdentificationAccess().getManufacturerAssignment_7(), "rule__ClassIdentification__ManufacturerAssignment_7");
					put(grammarAccess.getClassIdentificationAccess().getReferenceAssignment_8(), "rule__ClassIdentification__ReferenceAssignment_8");
					put(grammarAccess.getCommentsAccess().getCommandsTableAssignment(), "rule__Comments__CommandsTableAssignment");
					put(grammarAccess.getPreferencesAccess().getDocHomeAssignment_0(), "rule__Preferences__DocHomeAssignment_0");
					put(grammarAccess.getPreferencesAccess().getMakefileHomeAssignment_1(), "rule__Preferences__MakefileHomeAssignment_1");
					put(grammarAccess.getPreferencesAccess().getInstallHomeAssignment_2(), "rule__Preferences__InstallHomeAssignment_2");
					put(grammarAccess.getPreferencesAccess().getHtmlVersionAssignment_3(), "rule__Preferences__HtmlVersionAssignment_3");
					put(grammarAccess.getStateAccess().getNameAssignment_0(), "rule__State__NameAssignment_0");
					put(grammarAccess.getStateAccess().getDescriptionAssignment_1(), "rule__State__DescriptionAssignment_1");
					put(grammarAccess.getStateAccess().getStatusAssignment_2(), "rule__State__StatusAssignment_2");
					put(grammarAccess.getPropertyAccess().getNameAssignment_0(), "rule__Property__NameAssignment_0");
					put(grammarAccess.getPropertyAccess().getTypeAssignment_1(), "rule__Property__TypeAssignment_1");
					put(grammarAccess.getPropertyAccess().getStatusAssignment_2(), "rule__Property__StatusAssignment_2");
					put(grammarAccess.getPropertyAccess().getMandatoryAssignment_3(), "rule__Property__MandatoryAssignment_3");
					put(grammarAccess.getPropertyAccess().getDescriptionAssignment_4(), "rule__Property__DescriptionAssignment_4");
					put(grammarAccess.getPropertyAccess().getDefaultPropValueAssignment_6(), "rule__Property__DefaultPropValueAssignment_6");
					put(grammarAccess.getInheritanceStatusAccess().getAbstractAssignment_0(), "rule__InheritanceStatus__AbstractAssignment_0");
					put(grammarAccess.getInheritanceStatusAccess().getInheritedAssignment_1(), "rule__InheritanceStatus__InheritedAssignment_1");
					put(grammarAccess.getInheritanceStatusAccess().getConcreteAssignment_2(), "rule__InheritanceStatus__ConcreteAssignment_2");
					put(grammarAccess.getInheritanceStatusAccess().getConcreteHereAssignment_3(), "rule__InheritanceStatus__ConcreteHereAssignment_3");
					put(grammarAccess.getInheritanceStatusAccess().getHasChangedAssignment_4(), "rule__InheritanceStatus__HasChangedAssignment_4");
					put(grammarAccess.getCommandAccess().getNameAssignment_0(), "rule__Command__NameAssignment_0");
					put(grammarAccess.getCommandAccess().getArginAssignment_1(), "rule__Command__ArginAssignment_1");
					put(grammarAccess.getCommandAccess().getArgoutAssignment_2(), "rule__Command__ArgoutAssignment_2");
					put(grammarAccess.getCommandAccess().getDescriptionAssignment_3(), "rule__Command__DescriptionAssignment_3");
					put(grammarAccess.getCommandAccess().getStatusAssignment_4(), "rule__Command__StatusAssignment_4");
					put(grammarAccess.getCommandAccess().getExecMethodAssignment_5(), "rule__Command__ExecMethodAssignment_5");
					put(grammarAccess.getCommandAccess().getDisplayLevelAssignment_6(), "rule__Command__DisplayLevelAssignment_6");
					put(grammarAccess.getCommandAccess().getPolledPeriodAssignment_7(), "rule__Command__PolledPeriodAssignment_7");
					put(grammarAccess.getCommandAccess().getExcludedStatesAssignment_9(), "rule__Command__ExcludedStatesAssignment_9");
					put(grammarAccess.getArgumentAccess().getTypeAssignment_0(), "rule__Argument__TypeAssignment_0");
					put(grammarAccess.getArgumentAccess().getDescriptionAssignment_1(), "rule__Argument__DescriptionAssignment_1");
					put(grammarAccess.getAttributeAccess().getNameAssignment_0(), "rule__Attribute__NameAssignment_0");
					put(grammarAccess.getAttributeAccess().getAttTypeAssignment_1(), "rule__Attribute__AttTypeAssignment_1");
					put(grammarAccess.getAttributeAccess().getDataTypeAssignment_2(), "rule__Attribute__DataTypeAssignment_2");
					put(grammarAccess.getAttributeAccess().getRwTypeAssignment_3(), "rule__Attribute__RwTypeAssignment_3");
					put(grammarAccess.getAttributeAccess().getDisplayLevelAssignment_4(), "rule__Attribute__DisplayLevelAssignment_4");
					put(grammarAccess.getAttributeAccess().getPolledPeriodAssignment_5(), "rule__Attribute__PolledPeriodAssignment_5");
					put(grammarAccess.getAttributeAccess().getMaxXAssignment_6(), "rule__Attribute__MaxXAssignment_6");
					put(grammarAccess.getAttributeAccess().getMaxYAssignment_7(), "rule__Attribute__MaxYAssignment_7");
					put(grammarAccess.getAttributeAccess().getAssociatedAttrAssignment_8(), "rule__Attribute__AssociatedAttrAssignment_8");
					put(grammarAccess.getAttributeAccess().getMemorizedAssignment_9(), "rule__Attribute__MemorizedAssignment_9");
					put(grammarAccess.getAttributeAccess().getMemorizedAtInitAssignment_10(), "rule__Attribute__MemorizedAtInitAssignment_10");
					put(grammarAccess.getAttributeAccess().getChangeEventAssignment_11(), "rule__Attribute__ChangeEventAssignment_11");
					put(grammarAccess.getAttributeAccess().getArchiveEventAssignment_12(), "rule__Attribute__ArchiveEventAssignment_12");
					put(grammarAccess.getAttributeAccess().getDataReadyEventAssignment_13(), "rule__Attribute__DataReadyEventAssignment_13");
					put(grammarAccess.getAttributeAccess().getStatusAssignment_14(), "rule__Attribute__StatusAssignment_14");
					put(grammarAccess.getAttributeAccess().getPropertiesAssignment_15(), "rule__Attribute__PropertiesAssignment_15");
					put(grammarAccess.getAttributeAccess().getAllocReadMemberAssignment_16(), "rule__Attribute__AllocReadMemberAssignment_16");
					put(grammarAccess.getAttributeAccess().getIsDynamicAssignment_17(), "rule__Attribute__IsDynamicAssignment_17");
					put(grammarAccess.getAttributeAccess().getReadExcludedStatesAssignment_19(), "rule__Attribute__ReadExcludedStatesAssignment_19");
					put(grammarAccess.getAttributeAccess().getWriteExcludedStatesAssignment_21(), "rule__Attribute__WriteExcludedStatesAssignment_21");
					put(grammarAccess.getFireEventsAccess().getFireAssignment_0(), "rule__FireEvents__FireAssignment_0");
					put(grammarAccess.getFireEventsAccess().getLibCheckCriteriaAssignment_1(), "rule__FireEvents__LibCheckCriteriaAssignment_1");
					put(grammarAccess.getAttrPropertiesAccess().getDescriptionAssignment_0(), "rule__AttrProperties__DescriptionAssignment_0");
					put(grammarAccess.getAttrPropertiesAccess().getLabelAssignment_1(), "rule__AttrProperties__LabelAssignment_1");
					put(grammarAccess.getAttrPropertiesAccess().getUnitAssignment_2(), "rule__AttrProperties__UnitAssignment_2");
					put(grammarAccess.getAttrPropertiesAccess().getStandardUnitAssignment_3(), "rule__AttrProperties__StandardUnitAssignment_3");
					put(grammarAccess.getAttrPropertiesAccess().getDisplayUnitAssignment_4(), "rule__AttrProperties__DisplayUnitAssignment_4");
					put(grammarAccess.getAttrPropertiesAccess().getFormatAssignment_5(), "rule__AttrProperties__FormatAssignment_5");
					put(grammarAccess.getAttrPropertiesAccess().getMaxValueAssignment_6(), "rule__AttrProperties__MaxValueAssignment_6");
					put(grammarAccess.getAttrPropertiesAccess().getMinValueAssignment_7(), "rule__AttrProperties__MinValueAssignment_7");
					put(grammarAccess.getAttrPropertiesAccess().getMaxAlarmAssignment_8(), "rule__AttrProperties__MaxAlarmAssignment_8");
					put(grammarAccess.getAttrPropertiesAccess().getMinAlarmAssignment_9(), "rule__AttrProperties__MinAlarmAssignment_9");
					put(grammarAccess.getAttrPropertiesAccess().getMaxWarningAssignment_10(), "rule__AttrProperties__MaxWarningAssignment_10");
					put(grammarAccess.getAttrPropertiesAccess().getMinWarningAssignment_11(), "rule__AttrProperties__MinWarningAssignment_11");
					put(grammarAccess.getAttrPropertiesAccess().getDeltaTimeAssignment_12(), "rule__AttrProperties__DeltaTimeAssignment_12");
					put(grammarAccess.getAttrPropertiesAccess().getDeltaValueAssignment_13(), "rule__AttrProperties__DeltaValueAssignment_13");
					put(grammarAccess.getAdditionalFileAccess().getNameAssignment_0(), "rule__AdditionalFile__NameAssignment_0");
					put(grammarAccess.getAdditionalFileAccess().getPathAssignment_1(), "rule__AdditionalFile__PathAssignment_1");
				}
			};
		}
		return nameMappings.get(element);
	}
	
	@Override
	protected Collection<FollowElement> getFollowElements(AbstractInternalContentAssistParser parser) {
		try {
			fr.esrf.tango.pogo.contentassist.antlr.internal.InternalPogoDslParser typedParser = (fr.esrf.tango.pogo.contentassist.antlr.internal.InternalPogoDslParser) parser;
			typedParser.entryRulePogoSystem();
			return typedParser.getFollowElements();
		} catch(RecognitionException ex) {
			throw new RuntimeException(ex);
		}		
	}
	
	@Override
	protected String[] getInitialHiddenTokens() {
		return new String[] { "RULE_WS", "RULE_ML_COMMENT", "RULE_SL_COMMENT" };
	}
	
	public PogoDslGrammarAccess getGrammarAccess() {
		return this.grammarAccess;
	}
	
	public void setGrammarAccess(PogoDslGrammarAccess grammarAccess) {
		this.grammarAccess = grammarAccess;
	}
}
