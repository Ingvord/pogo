/**
 * <copyright>
 * </copyright>
 *
 */
package fr.esrf.tango.pogo.pogoDsl;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Class Description</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getDescription <em>Description</em>}</li>
 *   <li>{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getTitle <em>Title</em>}</li>
 *   <li>{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getSourcePath <em>Source Path</em>}</li>
 *   <li>{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getInheritances <em>Inheritances</em>}</li>
 *   <li>{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getLanguage <em>Language</em>}</li>
 *   <li>{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getFilestogenerate <em>Filestogenerate</em>}</li>
 *   <li>{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getIdentification <em>Identification</em>}</li>
 *   <li>{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getComments <em>Comments</em>}</li>
 * </ul>
 * </p>
 *
 * @see fr.esrf.tango.pogo.pogoDsl.PogoDslPackage#getClassDescription()
 * @model
 * @generated
 */
public interface ClassDescription extends EObject
{
  /**
   * Returns the value of the '<em><b>Description</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Description</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Description</em>' attribute.
   * @see #setDescription(String)
   * @see fr.esrf.tango.pogo.pogoDsl.PogoDslPackage#getClassDescription_Description()
   * @model
   * @generated
   */
  String getDescription();

  /**
   * Sets the value of the '{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getDescription <em>Description</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Description</em>' attribute.
   * @see #getDescription()
   * @generated
   */
  void setDescription(String value);

  /**
   * Returns the value of the '<em><b>Title</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Title</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Title</em>' attribute.
   * @see #setTitle(String)
   * @see fr.esrf.tango.pogo.pogoDsl.PogoDslPackage#getClassDescription_Title()
   * @model
   * @generated
   */
  String getTitle();

  /**
   * Sets the value of the '{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getTitle <em>Title</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Title</em>' attribute.
   * @see #getTitle()
   * @generated
   */
  void setTitle(String value);

  /**
   * Returns the value of the '<em><b>Source Path</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Source Path</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Source Path</em>' attribute.
   * @see #setSourcePath(String)
   * @see fr.esrf.tango.pogo.pogoDsl.PogoDslPackage#getClassDescription_SourcePath()
   * @model
   * @generated
   */
  String getSourcePath();

  /**
   * Sets the value of the '{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getSourcePath <em>Source Path</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Source Path</em>' attribute.
   * @see #getSourcePath()
   * @generated
   */
  void setSourcePath(String value);

  /**
   * Returns the value of the '<em><b>Inheritances</b></em>' containment reference list.
   * The list contents are of type {@link fr.esrf.tango.pogo.pogoDsl.Inheritance}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Inheritances</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Inheritances</em>' containment reference list.
   * @see fr.esrf.tango.pogo.pogoDsl.PogoDslPackage#getClassDescription_Inheritances()
   * @model containment="true"
   * @generated
   */
  EList<Inheritance> getInheritances();

  /**
   * Returns the value of the '<em><b>Language</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Language</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Language</em>' attribute.
   * @see #setLanguage(String)
   * @see fr.esrf.tango.pogo.pogoDsl.PogoDslPackage#getClassDescription_Language()
   * @model
   * @generated
   */
  String getLanguage();

  /**
   * Sets the value of the '{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getLanguage <em>Language</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Language</em>' attribute.
   * @see #getLanguage()
   * @generated
   */
  void setLanguage(String value);

  /**
   * Returns the value of the '<em><b>Filestogenerate</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Filestogenerate</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Filestogenerate</em>' attribute.
   * @see #setFilestogenerate(String)
   * @see fr.esrf.tango.pogo.pogoDsl.PogoDslPackage#getClassDescription_Filestogenerate()
   * @model
   * @generated
   */
  String getFilestogenerate();

  /**
   * Sets the value of the '{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getFilestogenerate <em>Filestogenerate</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Filestogenerate</em>' attribute.
   * @see #getFilestogenerate()
   * @generated
   */
  void setFilestogenerate(String value);

  /**
   * Returns the value of the '<em><b>Identification</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Identification</em>' containment reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Identification</em>' containment reference.
   * @see #setIdentification(ClassIdentification)
   * @see fr.esrf.tango.pogo.pogoDsl.PogoDslPackage#getClassDescription_Identification()
   * @model containment="true"
   * @generated
   */
  ClassIdentification getIdentification();

  /**
   * Sets the value of the '{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getIdentification <em>Identification</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Identification</em>' containment reference.
   * @see #getIdentification()
   * @generated
   */
  void setIdentification(ClassIdentification value);

  /**
   * Returns the value of the '<em><b>Comments</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Comments</em>' containment reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Comments</em>' containment reference.
   * @see #setComments(Comments)
   * @see fr.esrf.tango.pogo.pogoDsl.PogoDslPackage#getClassDescription_Comments()
   * @model containment="true"
   * @generated
   */
  Comments getComments();

  /**
   * Sets the value of the '{@link fr.esrf.tango.pogo.pogoDsl.ClassDescription#getComments <em>Comments</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Comments</em>' containment reference.
   * @see #getComments()
   * @generated
   */
  void setComments(Comments value);

} // ClassDescription
