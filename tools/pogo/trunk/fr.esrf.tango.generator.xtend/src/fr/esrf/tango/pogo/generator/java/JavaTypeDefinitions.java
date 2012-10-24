package fr.esrf.tango.pogo.generator.java;

import fr.esrf.tango.pogo.pogoDsl.Attribute;
import fr.esrf.tango.pogo.pogoDsl.BooleanArrayType;
import fr.esrf.tango.pogo.pogoDsl.BooleanType;
import fr.esrf.tango.pogo.pogoDsl.CharArrayType;
import fr.esrf.tango.pogo.pogoDsl.ConstStringType;
import fr.esrf.tango.pogo.pogoDsl.DevIntType;
import fr.esrf.tango.pogo.pogoDsl.DoubleArrayType;
import fr.esrf.tango.pogo.pogoDsl.DoubleStringArrayType;
import fr.esrf.tango.pogo.pogoDsl.DoubleType;
import fr.esrf.tango.pogo.pogoDsl.DoubleVectorType;
import fr.esrf.tango.pogo.pogoDsl.EncodedType;
import fr.esrf.tango.pogo.pogoDsl.FloatArrayType;
import fr.esrf.tango.pogo.pogoDsl.FloatType;
import fr.esrf.tango.pogo.pogoDsl.FloatVectorType;
import fr.esrf.tango.pogo.pogoDsl.IntArrayType;
import fr.esrf.tango.pogo.pogoDsl.IntType;
import fr.esrf.tango.pogo.pogoDsl.IntVectorType;
import fr.esrf.tango.pogo.pogoDsl.LongArrayType;
import fr.esrf.tango.pogo.pogoDsl.LongStringArrayType;
import fr.esrf.tango.pogo.pogoDsl.LongType;
import fr.esrf.tango.pogo.pogoDsl.PropType;
import fr.esrf.tango.pogo.pogoDsl.ShortArrayType;
import fr.esrf.tango.pogo.pogoDsl.ShortType;
import fr.esrf.tango.pogo.pogoDsl.ShortVectorType;
import fr.esrf.tango.pogo.pogoDsl.StateType;
import fr.esrf.tango.pogo.pogoDsl.StringArrayType;
import fr.esrf.tango.pogo.pogoDsl.StringType;
import fr.esrf.tango.pogo.pogoDsl.StringVectorType;
import fr.esrf.tango.pogo.pogoDsl.Type;
import fr.esrf.tango.pogo.pogoDsl.UCharType;
import fr.esrf.tango.pogo.pogoDsl.UIntArrayType;
import fr.esrf.tango.pogo.pogoDsl.UIntType;
import fr.esrf.tango.pogo.pogoDsl.ULongArrayType;
import fr.esrf.tango.pogo.pogoDsl.ULongType;
import fr.esrf.tango.pogo.pogoDsl.UShortArrayType;
import fr.esrf.tango.pogo.pogoDsl.UShortType;
import fr.esrf.tango.pogo.pogoDsl.VoidType;


public class JavaTypeDefinitions {
	/**
	 * Property Type utilities
	 */
	public static String javaPropType (PropType propType) {
		
		if (propType instanceof BooleanType)	   return "boolean";
		if (propType instanceof ShortType) 		   return "short";
		if (propType instanceof IntType)           return "int";
		if (propType instanceof UShortType)        return "short";
		if (propType instanceof UIntType)      	   return "int";
		if (propType instanceof FloatType)         return "float";
		if (propType instanceof DoubleType)        return "double";
		if (propType instanceof StringType)        return "String";
		if (propType instanceof ShortVectorType)   return "short[]";
		if (propType instanceof IntVectorType)     return "int[]";
		if (propType instanceof FloatVectorType)   return "float[]";
		if (propType instanceof DoubleVectorType)  return "double[]";
		if (propType instanceof StringVectorType)  return "String[]";
		return "";
	}

	/**
	 * Type utilities
	 */
	public static String javaType (Type type) {
		if (type instanceof VoidType)				return "void";
		if (type instanceof BooleanType)			return "boolean";
		if (type instanceof ShortType)				return "short";
		if (type instanceof IntType)				return "int";
		if (type instanceof FloatType)				return "float";
		if (type instanceof DoubleType)				return "double";
		if (type instanceof UShortType)				return "short";
		if (type instanceof UIntType)				return "int";
		if (type instanceof StringType)				return "String";
		if (type instanceof CharArrayType)			return "byte[]";
		if (type instanceof ShortArrayType)			return "short[]";
		if (type instanceof IntArrayType)			return "int[]";
		if (type instanceof FloatArrayType)			return "float[]";
		if (type instanceof DoubleArrayType)		return "double[]";
		if (type instanceof UShortArrayType)		return "short[]";
		if (type instanceof UIntArrayType)			return "int[]";
		if (type instanceof StringArrayType)		return "String[]";
		if (type instanceof LongStringArrayType)	return "DevVarLongStringArray";
		if (type instanceof DoubleStringArrayType)	return "DevVarDoubleStringArray";
		if (type instanceof StateType)				return "DevState";
		if (type instanceof ConstStringType)		return "String";
		if (type instanceof BooleanArrayType)		return "boolean[]";
		if (type instanceof UCharType)				return "byte";
		if (type instanceof LongType)				return "long";
		if (type instanceof ULongType)				return "long";
		if (type instanceof LongArrayType)			return "long[]";
		if (type instanceof ULongArrayType)			return "long";
		if (type instanceof DevIntType)				return "int";
		if (type instanceof EncodedType)			return "DevEncoded";
		return "";
	}

	/**
	 * Type enum
	 */
	public static String javaTypeEnum (Type type) {
		if (type instanceof VoidType)				return "DevVoid";
		if (type instanceof BooleanType)			return "DevBoolean";
		if (type instanceof ShortType)				return "DevShort";
		if (type instanceof IntType)				return "DevLong";
		if (type instanceof FloatType)				return "DevFloat";
		if (type instanceof DoubleType)				return "DevDouble";
		if (type instanceof UShortType)				return "DevUShort";
		if (type instanceof UIntType)				return "DevULong";
		if (type instanceof StringType)				return "DevString";
		if (type instanceof CharArrayType)			return "DevVarCharArray";
		if (type instanceof ShortArrayType)			return "DevVarShortArray";
		if (type instanceof IntArrayType)			return "DevVarLongArray";
		if (type instanceof FloatArrayType)			return "DevVarFloatArray";
		if (type instanceof DoubleArrayType)		return "DevVarDoubleArray";
		if (type instanceof UShortArrayType)		return "DevVarUShortArray";
		if (type instanceof UIntArrayType)			return "DevVarULongArray";
		if (type instanceof StringArrayType)		return "DevVarStringArray";
		if (type instanceof LongStringArrayType)	return "DevVarLongStringArray";
		if (type instanceof DoubleStringArrayType)	return "DevVarDoubleStringArray";
		if (type instanceof StateType)				return "DevState";
		if (type instanceof ConstStringType)		return "DevConstString";
		if (type instanceof BooleanArrayType)		return "DevVarBooleanArray";
		if (type instanceof UCharType)				return "DevUChar";
		if (type instanceof LongType)				return "DevLong64";
		if (type instanceof ULongType)				return "DevULong64";
		if (type instanceof LongArrayType)			return "DevLong64Array";
		if (type instanceof ULongArrayType)			return "DevULong64Array";
		if (type instanceof DevIntType)				return "DevInt";
		if (type instanceof EncodedType)			return "DevEncoded";
		return "";
	}

	//===========================================================
	//===========================================================
	public String defaultValue(Attribute attribute) {
		Type type = attribute.getDataType();
		String	att = attribute.getAttType().toLowerCase();
		
		if (type instanceof VoidType)		return "";
		if (type instanceof BooleanType)	return (att.equals("scalar"))? "false" : "ptr";
		if (type instanceof ShortType)		return (att.equals("scalar"))? "0"     : "ptr";
		if (type instanceof IntType)		return (att.equals("scalar"))? "0"     : "ptr";
		if (type instanceof FloatType)		return (att.equals("scalar"))? "0.0"   : "ptr";
		if (type instanceof DoubleType)		return (att.equals("scalar"))? "0.0"   : "ptr";
		if (type instanceof UShortType)		return (att.equals("scalar"))? "0"     : "ptr";
		if (type instanceof UIntType)		return (att.equals("scalar"))? "0"     : "ptr";
		if (type instanceof StringType)		return (att.equals("scalar"))? "\"\""  : "ptr";
		if (type instanceof DevIntType)		return (att.equals("scalar"))? "0"     : "ptr";
		if (type instanceof StateType)		return (att.equals("scalar"))? "Tango::UNKNOWN" : "ptr";
		if (type instanceof EncodedType)	return "ptr";
		return "0";
	}

}